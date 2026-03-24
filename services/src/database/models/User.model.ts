import mongoose, { Schema, Document, Model } from 'mongoose';
import { User } from '../../shared/interfaces/user.interface';
import { hashPassword, comparePassword } from '../../utils/crypto';

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
  const userDoc = this as UserDocument;
  if (!userDoc.isModified('passwordHash')) {
    return next();
  }

  try {
    const hashedPassword = await hashPassword(userDoc.get('passwordHash') as string);
    userDoc.set('passwordHash', hashedPassword);
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
