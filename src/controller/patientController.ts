import { NextFunction, Request, Response } from 'express';
import patientRiskSchema from '../models/patientRiskSchema';
import fs from 'fs';
import { generatePatients } from '../util/seeder';

// CREATE
export async function createPatient(req: Request, res: Response) {
  try {
    const patient = new patientRiskSchema(req.body);
    const saved = await patient.save();
    res.status(201).json(saved);
  } catch (error) {
    res.status(400).json({ message: 'Erro ao criar paciente', error });
  }
}

// READ ALL
export async function getAllPatients(req: Request, res: Response) {
  try {
    const patients = await patientRiskSchema.find();
    res.status(200).json(patients);
  } catch (error) {
    res.status(500).json({ message: 'Erro ao buscar pacientes', error });
  }
}

// READ BY ID
export async function getPatientById(req: Request, res: Response, next: NextFunction) {
  try {
    const { id } = req.params;
    const patient = await patientRiskSchema.findById(id);

    if (!patient) {
      return res.status(404).json({ message: 'Paciente não encontrado' });
    }

    res.status(200).json(patient);
  } catch (error) {
    res.status(500).json({ message: 'Erro ao buscar paciente', error });
  }
}

// UPDATE
export async function updatePatient(req: Request, res: Response) {
  try {
    const { id } = req.params;
    const updated = await patientRiskSchema.findByIdAndUpdate(id, req.body, {
      new: true,
      runValidators: true
    });

    if (!updated) {
      return res.status(404).json({ message: 'Paciente não encontrado' });
    }

    res.status(200).json(updated);
  } catch (error) {
    res.status(400).json({ message: 'Erro ao atualizar paciente', error });
  }
}

// DELETE
export async function deletePatient(req: Request, res: Response) {
  try {
    const { id } = req.params;
    const deleted = await patientRiskSchema.findByIdAndDelete(id);

    if (!deleted) {
      return res.status(404).json({ message: 'Paciente não encontrado' });
    }

    res.status(200).json({ message: 'Paciente excluído com sucesso' });
  } catch (error) {
    res.status(500).json({ message: 'Erro ao excluir paciente', error });
  }
}

export async function exportDataset(req: Request, res: Response) {
  const patients = await patientRiskSchema.find();
  fs.writeFileSync('./data/patients.json', JSON.stringify(patients, null, 2));
  return res.status(200).json({message: 'Dataset exportado para data/patients.json'});
}

export async function seedPatient(req: Request, res: Response) {
  try {
    const patients = generatePatients(10);
    await patientRiskSchema.insertMany(patients);
    res.status(201).json({ message: 'Pacientes criados com sucesso' });
  } catch (error) {
    res.status(500).json({ message: 'Erro ao criar pacientes', error });
  }
}