import { NextFunction, Request, Response } from 'express';
import patientSchema from '../models/patientSchema';
import fs from 'fs';

// CREATE
export async function createPatient(req: Request, res: Response) {
  try {
    const patient = new patientSchema(req.body);
    const saved = await patient.save();
    res.status(201).json(saved);
  } catch (error) {
    res.status(400).json({ message: 'Erro ao criar paciente', error });
  }
}

// READ ALL
export async function getAllPatients(req: Request, res: Response) {
  try {
    const patients = await patientSchema.find();
    res.status(200).json(patients);
  } catch (error) {
    res.status(500).json({ message: 'Erro ao buscar pacientes', error });
  }
}

// READ BY ID
export async function getPatientById(req: Request, res: Response, next: NextFunction) {
  try {
    const { id } = req.params;
    const patient = await patientSchema.findById(id);

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
    const updated = await patientSchema.findByIdAndUpdate(id, req.body, {
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
    const deleted = await patientSchema.findByIdAndDelete(id);

    if (!deleted) {
      return res.status(404).json({ message: 'Paciente não encontrado' });
    }

    res.status(200).json({ message: 'Paciente excluído com sucesso' });
  } catch (error) {
    res.status(500).json({ message: 'Erro ao excluir paciente', error });
  }
}

export async function exportDataset(req: Request, res: Response) {
  const patients = await patientSchema.find();
  fs.writeFileSync('./data/patients.json', JSON.stringify(patients, null, 2));
  return res.status(200).json({message: 'Dataset exportado para data/patients.json'});
}