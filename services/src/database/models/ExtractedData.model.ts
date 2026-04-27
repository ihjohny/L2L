import mongoose, { Schema, Document, Model } from 'mongoose';
import { BaseEntity } from '../../shared/interfaces/base.interface';

// Interface defining the document structure
export interface ExtractedData extends BaseEntity {
  linkId: string;
  url: string;
  content: string; // The raw extracted text
}

// Interface for creation DTO
export interface CreateExtractedDataDto {
  linkId: string;
  url: string;
  content: string;
}

// Schema Document interface
interface ExtractedDataDocument extends Omit<ExtractedData, '_id'>, Document {}

// Schema definition
const extractedDataSchema = new Schema(
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
    content: {
      type: String,
      required: true
    }
  },
  {
    timestamps: true
  }
);

// Indexes
extractedDataSchema.index({ linkId: 1 });
extractedDataSchema.index({ createdAt: -1 });

// Static methods
extractedDataSchema.statics.findByLink = function (linkId: string) {
  return this.findOne({ linkId });
};

// Model interface linking statics
interface ExtractedDataModelType extends Model<ExtractedDataDocument> {
  findByLink(linkId: string): Promise<ExtractedDataDocument | null>;
}

const ExtractedDataModel = mongoose.model<ExtractedDataDocument, ExtractedDataModelType>('ExtractedData', extractedDataSchema);

export default ExtractedDataModel;
