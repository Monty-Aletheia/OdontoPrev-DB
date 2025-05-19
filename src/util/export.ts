// utils/export.ts
import fs from 'fs';
import patientSchema from '../models/patientSchema';

export async function exportDataset() {
  const patients = await patientSchema.find();
  fs.writeFileSync('./data/patients.json', JSON.stringify(patients, null, 2));
  console.log('✅ Dataset exportado para data/patients.json');
}
