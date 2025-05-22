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

export enum PlanType {
  BASICO = 'BASICO',
  INTERMEDIARIO = 'INTERMEDIARIO',
  AVANCADO = 'AVANCADO'
}

export interface IPatientRisk extends Document {
  idade: number;
  genero: Gender;
  frequencia_consultas: number;
  aderencia_tratamento: number;
  historico_caries: boolean;
  doenca_periodontal: boolean;
  numero_implantes: number;
  fumante: boolean;
  alcoolismo: boolean;
  escovacao_diaria: number;
  uso_fio_dental: number;
  doencas_sistemicas: string;
  medicamentos_uso_continuo: boolean;
  numero_sinistros_previos: number;
  valor_medio_sinistros: number;
  tratamentos_complexos_previos: boolean;
  tipo_plano: PlanType;
}

const PatientRiskSchema: Schema<IPatientRisk> = new Schema(
{
    idade: { type: Number, required: true },
    genero: { 
      type: String, 
      enum: Object.values(Gender), 
      required: true 
    },
    frequencia_consultas: { type: Number, required: true },
    aderencia_tratamento: { type: Number, default: 0 },
    historico_caries: { type: Boolean, required: true },
    doenca_periodontal: { type: Boolean, required: true },
    numero_implantes: { type: Number, required: true },
    fumante: { type: Boolean, required: true },
    alcoolismo: { type: Boolean, required: true },
    escovacao_diaria: { type: Number, required: true },
    uso_fio_dental: { type: Number, required: true },
    doencas_sistemicas: { type: String, required: true },
    medicamentos_uso_continuo: { type: Boolean, required: true },
    numero_sinistros_previos: { type: Number, default: 0 },
    valor_medio_sinistros: { type: Number, default: 0 },
    tratamentos_complexos_previos: { type: Boolean, required: true },
    tipo_plano: { 
      type: String, 
      enum: Object.values(PlanType), 
      required: true 
    }
  },
  {
    collection: 'tb_patientR isk',
    timestamps: true
  }
);


export default mongoose.model<IPatientRisk>('PatientRisk', PatientRiskSchema);
