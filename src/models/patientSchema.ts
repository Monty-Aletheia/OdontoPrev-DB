import mongoose, { Schema, Document } from 'mongoose';

export enum Gender {
  MALE = 'MALE',
  FEMALE = 'FEMALE',
  OTHER = 'OTHER'
}

export enum RiskStatus {
  LOW = 'LOW',
  MEDIUM = 'MEDIUM',
  HIGH = 'HIGH'
}

export interface IPatient extends Document {
  name: string;
  birthday: Date;
  gender: Gender;
  riskStatus: RiskStatus;
  consultationFrequency?: number;
  associatedClaims?: string;
}

const PatientSchema: Schema<IPatient> = new Schema(
  {
    name: { type: String, required: true },
    birthday: { type: Date, required: true },
    gender: {
      type: String,
      enum: Object.values(Gender),
      required: true
    },
    riskStatus: {
      type: String,
      enum: Object.values(RiskStatus),
      required: true
    },
    consultationFrequency: {
      type: Number,
      default: 0
    },
    associatedClaims: {
      type: String
    }
  },
  {
    collection: 'tb_patient',
    timestamps: true 
  }
);

export default mongoose.model<IPatient>('Patient', PatientSchema);
