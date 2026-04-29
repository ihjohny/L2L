import mongoose, { Schema, Document, Model } from 'mongoose';
import { BaseEntity } from '../../shared/interfaces/base.interface';

// Interface defining the document structure
export interface ExtractedContent extends BaseEntity {
  linkId: string;
  url: string;
  fetchedAt: Date;
  title: string | null;
  description: string | null;
  mainContent: string;
  contentLength: number;
}

// Schema Document interface
interface ExtractedContentDocument extends Omit<ExtractedContent, '_id'>, Document {}

// Schema definition
const extractedContentSchema = new Schema(
  {
    linkId: {
      type: Schema.Types.ObjectId,
      ref: 'Link',
      required: true,
      index: true,
      unique: true // A single link maps to an exclusive extraction cache
    },
    url: {
      type: String,
      required: true,
      trim: true
    },
    fetchedAt: {
      type: Date,
      required: true
    },
    title: {
      type: String,
      default: null,
      trim: true
    },
    description: {
      type: String,
      default: null,
      trim: true
    },
    mainContent: {
      type: String,
      required: true
    },
    contentLength: {
      type: Number,
      required: true,
      default: 0
    }
  },
  {
    timestamps: true
  }
);

// Indexes
extractedContentSchema.index({ linkId: 1 });
extractedContentSchema.index({ createdAt: -1 });

// Static methods
extractedContentSchema.statics.findByLink = function (linkId: string) {
  return this.findOne({ linkId });
};

// Model interface linking statics
interface ExtractedContentModelType extends Model<ExtractedContentDocument> {
  findByLink(linkId: string): Promise<ExtractedContentDocument | null>;
}

const ExtractedContentModel = mongoose.model<ExtractedContentDocument, ExtractedContentModelType>('ExtractedContent', extractedContentSchema);

export default ExtractedContentModel;
