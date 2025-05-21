import { Express, Router } from 'express';
import { createPatient, getAllPatients, getPatientById, updatePatient, deletePatient, exportDataset, seedPatient } from '../controller/patientController';

export default (app: Express): void => {
    const router : Router = Router();
    router.post('/patient', async (req, res) => {
        await createPatient(req, res);
    });
    router.get('/patient', async (req, res) => {
        await getAllPatients(req, res);
    });
    router.get('/export-dataset', async (req, res) => {
        await exportDataset(req, res);
    });
    router.get('/patient/:id', async (req, res, next) => {
        await getPatientById(req, res, next);
    });
    router.put('/patient/:id', async (req, res) => {
        await updatePatient(req, res);
    });
    router.delete('/patient/:id', async (req, res) => {
        await deletePatient(req, res);
    });
    router.get('/patient/:id/claims', async (req, res) => {
        await seedPatient(req, res)
    });
    app.use('/api', router);
}