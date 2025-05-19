import { Express, Router } from 'express';
import { createPatient, getAllPatients, getPatientById, updatePatient, deletePatient } from '../controller/patientController';

export default (app: Express): void => {
    const router : Router = Router();
    router.post('/patient', createPatient);
    router.get('/patient', getAllPatients);
    router.get('/patient/:id', async (req, res, next) => {
    await getPatientById(req, res, next);
    });
    router.put('/patient/:id', async (req, res) => {
    await updatePatient(req, res);
    });
    router.delete('/patient/:id', async (req, res) => {
    await deletePatient(req, res);
    });
    app.use('/api', router);
}