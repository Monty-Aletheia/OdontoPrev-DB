import { faker } from "@faker-js/faker";
import { Gender, RiskStatus, PlanType } from "../models/patientRiskSchema";

function generateRandomPatient() {
  return {
    idade: faker.number.int({ min: 18, max: 90 }),
    genero: faker.helpers.arrayElement(Object.values(Gender)),
    frequencia_consultas: faker.number.int({ min: 0, max: 12 }),
    aderencia_tratamento: faker.number.int({ min: 0, max: 2 }),
    historico_caries: faker.datatype.boolean(),
    doenca_periodontal: faker.datatype.boolean(),
    numero_implantes: faker.number.int({ min: 0, max: 5 }),
    fumante: faker.datatype.boolean(),
    alcoolismo: faker.datatype.boolean(),
    escovacao_diaria: faker.number.int({ min: 0, max: 5 }),
    uso_fio_dental: faker.number.int({ min: 0, max: 2 }),
    doencas_sistemicas: faker.lorem.words(2),
    medicamentos_uso_continuo: faker.datatype.boolean(),
    numero_sinistros_previos: faker.number.int({ min: 0, max: 10 }),
    valor_medio_sinistros: faker.number.float({ min: 0, max: 1000}),
    tratamentos_complexos_previos: faker.datatype.boolean(),
    tipo_plano: faker.helpers.arrayElement(Object.values(PlanType)),
    createdAt: new Date(),
    updatedAt: new Date()
  };
}

export function generatePatients(count = 10) {
  return Array.from({ length: count }, generateRandomPatient);
}