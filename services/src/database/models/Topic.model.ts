import mongoose, { Schema, Document, Model } from 'mongoose';
import { Topic } from '../../shared/interfaces/content.interface';

interface TopicDocument extends Omit<Topic, '_id'>, Document {}

const topicSchema = new Schema(
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
    color: {
      type: String,
      required: true,
      default: '#007AFF'
    },
    icon: {
      type: String
    },
    isPublic: {
      type: Boolean,
      default: false,
      index: true
    },
    projects: [{
      type: Schema.Types.ObjectId,
      ref: 'Project'
    }],
    tags: [{
      type: String,
      trim: true,
      lowercase: true
    }]
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
topicSchema.index({ userId: 1, createdAt: -1 });
topicSchema.index({ isPublic: 1, createdAt: -1 });
topicSchema.index({ tags: 1 });
topicSchema.index({ name: 'text', description: 'text' });

// Virtual for project count
topicSchema.virtual('projectCount').get(function () {
  return this.projects?.length || 0;
});

// Static method to find by user
topicSchema.statics.findByUser = function (userId: string) {
  return this.find({ userId }).sort({ createdAt: -1 });
};

// Static method to find public topics
topicSchema.statics.findPublic = function () {
  return this.find({ isPublic: true }).sort({ createdAt: -1 });
};

interface TopicModel extends Model<TopicDocument> {
  findByUser(userId: string): Promise<TopicDocument[]>;
  findPublic(): Promise<TopicDocument[]>;
}

const TopicModel = mongoose.model<TopicDocument, TopicModel>('Topic', topicSchema);

export default TopicModel;
