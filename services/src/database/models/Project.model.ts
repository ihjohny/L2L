import mongoose, { Schema, Document, Model } from 'mongoose';
import { Project, DifficultyLevel } from '../../shared/interfaces/content.interface';

interface ProjectDocument extends Omit<Project, '_id'>, Document {}

const achievementSchema = new Schema({
  id: { type: String, required: true },
  title: { type: String, required: true },
  description: { type: String, required: true },
  iconUrl: { type: String },
  unlockedAt: { type: Date, default: Date.now }
});

const gamificationSchema = new Schema({
  points: { type: Number, default: 0 },
  badges: [{ type: String }],
  achievements: [achievementSchema]
});

const progressSchema = new Schema({
  completionPercentage: { type: Number, default: 0, min: 0, max: 100 },
  lastAccessed: { type: Date, default: Date.now },
  timeSpent: { type: Number, default: 0 }, // in minutes
  entitiesCompleted: { type: Number, default: 0 },
  totalEntities: { type: Number, default: 0 }
});

const projectSchema = new Schema(
  {
    name: {
      type: String,
      required: true,
      trim: true,
      maxlength: 100
    },
    description: {
      type: String,
      required: true,
      maxlength: 500
    },
    userId: {
      type: Schema.Types.ObjectId,
      ref: 'User',
      required: true,
      index: true
    },
    tags: [{
      type: String,
      trim: true,
      lowercase: true
    }],
    entities: [{
      type: Schema.Types.ObjectId,
      ref: 'Entity'
    }],
    isPublic: {
      type: Boolean,
      default: false,
      index: true
    },
    collaborators: [{
      type: Schema.Types.ObjectId,
      ref: 'User'
    }],
    progress: {
      type: progressSchema,
      default: {}
    },
    gamification: {
      type: gamificationSchema,
      default: {}
    },
    difficulty: {
      type: String,
      enum: ['beginner', 'intermediate', 'advanced', 'expert'],
      default: 'intermediate'
    },
    estimatedTime: {
      type: Number,
      default: 0
    }
  },
  {
    timestamps: true,
    toJSON: {
      virtuals: true
    },
    toObject: {
      virtuals: true
    }
  }
);

// Indexes
projectSchema.index({ userId: 1, createdAt: -1 });
projectSchema.index({ isPublic: 1, createdAt: -1 });
projectSchema.index({ tags: 1 });
projectSchema.index({ 'progress.completionPercentage': -1 });
projectSchema.index({ 'gamification.points': -1 });
projectSchema.index({ name: 'text', description: 'text' });

// Virtual for entity count
projectSchema.virtual('entityCount').get(function () {
  return this.entities?.length || 0;
});

// Method to update progress
projectSchema.methods.updateProgress = function () {
  const totalEntities = this.entities?.length || 0;
  const entitiesCompleted = this.progress?.entitiesCompleted || 0;
  const completionPercentage = totalEntities > 0
    ? Math.round((entitiesCompleted / totalEntities) * 100)
    : 0;

  this.progress.completionPercentage = completionPercentage;
  this.progress.lastAccessed = new Date();
  this.progress.totalEntities = totalEntities;

  return this.save();
};

// Method to add points
projectSchema.methods.addPoints = function (points: number) {
  this.gamification.points += points;
  return this.save();
};

// Static method to find by user
projectSchema.statics.findByUser = function (userId: string) {
  return this.find({ userId })
    .sort({ createdAt: -1 });
};

// Static method to find public projects
projectSchema.statics.findPublic = function () {
  return this.find({ isPublic: true })
    .populate('userId', 'username profile.firstName profile.lastName profile.avatar')
    .sort({ 'gamification.points': -1 });
};

interface ProjectModel extends Model<ProjectDocument> {
  findByUser(userId: string): Promise<ProjectDocument[]>;
  findPublic(): Promise<ProjectDocument[]>;
}

const ProjectModel = mongoose.model<ProjectDocument, ProjectModel>('Project', projectSchema);

export default ProjectModel;
