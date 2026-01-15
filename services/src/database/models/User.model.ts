import mongoose, { Schema, Document, Model } from 'mongoose';
import { User, UserTier } from '../../shared/interfaces/user.interface';
import { hashPassword, comparePassword } from '../../utils/crypto';

interface UserDocument extends Omit<User, '_id'>, Document {}

const userPreferencesSchema = new Schema({
  theme: {
    type: String,
    enum: ['light', 'dark', 'system'],
    default: 'system'
  },
  language: {
    type: String,
    default: 'en'
  },
  notifications: {
    email: { type: Boolean, default: true },
    push: { type: Boolean, default: true },
    marketing: { type: Boolean, default: false },
    learningReminders: { type: Boolean, default: true },
    socialUpdates: { type: Boolean, default: true }
  },
  privacy: {
    profileVisibility: {
      type: String,
      enum: ['public', 'private'],
      default: 'public'
    },
    activityVisibility: {
      type: String,
      enum: ['public', 'private'],
      default: 'public'
    },
    showProgress: { type: Boolean, default: true }
  }
});

const userSubscriptionSchema = new Schema({
  tier: {
    type: String,
    enum: ['free', 'premium', 'enterprise'],
    default: 'free'
  },
  startDate: { type: Date, default: Date.now },
  endDate: { type: Date },
  stripeCustomerId: { type: String },
  stripeSubscriptionId: { type: String },
  cancelAtPeriodEnd: { type: Boolean, default: false }
});

const userStatsSchema = new Schema({
  totalBookmarks: { type: Number, default: 0 },
  projectsCompleted: { type: Number, default: 0 },
  streakDays: { type: Number, default: 0 },
  totalPoints: { type: Number, default: 0 },
  currentLevel: { type: Number, default: 1 },
  quizzesCompleted: { type: Number, default: 0 },
  flashcardsReviewed: { type: Number, default: 0 }
});

const userProfileSchema = new Schema({
  firstName: { type: String, required: true, trim: true },
  lastName: { type: String, required: true, trim: true },
  avatar: { type: String },
  bio: { type: String, maxlength: 500 },
  preferences: {
    type: userPreferencesSchema,
    default: {}
  }
});

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
    username: {
      type: String,
      required: true,
      unique: true,
      lowercase: true,
      trim: true,
      minlength: 3,
      maxlength: 30,
      index: true
    },
    password: {
      type: String,
      required: true,
      select: false
    },
    profile: {
      type: userProfileSchema,
      required: true
    },
    subscription: {
      type: userSubscriptionSchema,
      default: {}
    },
    stats: {
      type: userStatsSchema,
      default: {}
    },
    isEmailVerified: {
      type: Boolean,
      default: false
    },
    lastLoginAt: {
      type: Date
    },
    refreshToken: {
      type: String,
      select: false
    }
  },
  {
    timestamps: true,
    toJSON: {
      transform: function (_doc, ret) {
        delete ret.password;
        delete ret.refreshToken;
        delete ret.__v;
        return ret;
      }
    },
    toObject: {
      transform: function (_doc, ret) {
        delete ret.password;
        delete ret.refreshToken;
        delete ret.__v;
        return ret;
      }
    }
  }
);

// Indexes
userSchema.index({ email: 1 }, { unique: true });
userSchema.index({ username: 1 }, { unique: true });
userSchema.index({ 'subscription.tier': 1 });
userSchema.index({ createdAt: -1 });
userSchema.index({ 'stats.totalPoints': -1 });

// Pre-save middleware to hash password
userSchema.pre('save', async function (next) {
  if (!this.isModified('password')) {
    return next();
  }

  try {
    const hashedPassword = await hashPassword(this.get('password'));
    this.set('password', hashedPassword);
    next();
  } catch (error: any) {
    next(error);
  }
});

// Method to compare password
userSchema.methods.comparePassword = async function (password: string): Promise<boolean> {
  return comparePassword(password, this.password);
};

// Method to get public profile
userSchema.methods.toPublicJSON = function () {
  const obj = this.toObject();
  delete obj.password;
  delete obj.refreshToken;
  return obj;
};

// Static method to find by email
userSchema.statics.findByEmail = function (email: string) {
  return this.findOne({ email: email.toLowerCase() });
};

// Static method to find by username
userSchema.statics.findByUsername = function (username: string) {
  return this.findOne({ username: username.toLowerCase() });
};

interface UserModel extends Model<UserDocument> {
  findByEmail(email: string): Promise<UserDocument | null>;
  findByUsername(username: string): Promise<UserDocument | null>;
}

const UserModel = mongoose.model<UserDocument, UserModel>('User', userSchema);

export default UserModel;
