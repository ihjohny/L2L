import mongoose, { Schema, Document, Model } from 'mongoose';
import { BaseEntity } from '../../shared/interfaces/base.interface';
import { hashPassword, comparePassword } from '../../utils/crypto';

export interface User extends BaseEntity {
  email: string;
  passwordHash: string;
  name: string;
  deletedAt?: Date | null;
  refreshToken?: string;
}

export interface CreateUserDto {
  email: string;
  password: string;
  name: string;
}

export interface LoginDto {
  email: string;
  password: string;
}

export interface AuthResponse {
  user: Omit<User, 'passwordHash'>;
  accessToken: string;
  refreshToken: string;
}

export interface JwtPayload {
  sub: string;
  email: string;
  iat: number;
  exp: number;
  permissions?: string[];
}

interface UserDocument extends Omit<User, '_id'>, Document {}

const userSchema = new Schema(
  {
    email: {
      type: String,
      required: true,
      unique: true,
      lowercase: true,
      trim: true,
      index: true
    },
    passwordHash: {
      type: String,
      required: true,
      select: false
    },
    name: {
      type: String,
      required: true,
      trim: true
    },
    deletedAt: {
      type: Date,
      default: null,
      index: true
    }
  },
  {
    timestamps: true,
    toJSON: {
      transform: function (_doc, ret: any) {
        delete ret.passwordHash;
        delete ret.__v;
        return ret;
      }
    },
    toObject: {
      transform: function (_doc, ret: any) {
        delete ret.passwordHash;
        delete ret.__v;
        return ret;
      }
    }
  }
);

// Indexes
userSchema.index({ email: 1 }, { unique: true });
userSchema.index({ deletedAt: 1 });

// Pre-save middleware to hash password
userSchema.pre('save', async function (next) {
  if (!this.isModified('passwordHash')) {
    return next();
  }

  try {
    const hashedPassword = await hashPassword(this.get('passwordHash') as string);
    this.set('passwordHash', hashedPassword);
    next();
  } catch (error: any) {
    next(error);
  }
});

// Method to compare password
userSchema.methods.comparePassword = async function (password: string): Promise<boolean> {
  // Need to explicitly select passwordHash field
  const user = await (this.constructor as Model<UserDocument>).findById(
    this._id,
    { passwordHash: 1 }
  );
  if (!user) {
    return false;
  }
  return comparePassword(password, user.passwordHash);
};

// Method to get public profile
userSchema.methods.toPublicJSON = function () {
  const obj = this.toObject();
  delete obj.passwordHash;
  return obj;
};

// Static method to find by email
userSchema.statics.findByEmail = function (email: string) {
  return this.findOne({ email: email.toLowerCase(), deletedAt: null });
};

// Static method to find by ID and ensure not deleted
userSchema.statics.findByIdActive = function (id: string) {
  return this.findOne({ _id: id, deletedAt: null });
};

interface UserModel extends Model<UserDocument> {
  findByEmail(email: string): Promise<UserDocument | null>;
  findByIdActive(id: string): Promise<UserDocument | null>;
}

const UserModel = mongoose.model<UserDocument, UserModel>('User', userSchema);

export default UserModel;
