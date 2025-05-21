import { faker } from "@faker-js/faker";
import { Gender, RiskStatus } from "../models/patientSchema";

function generateRandomPatient() {
  return {
    name: faker.person.fullName(),
    birthday: faker.date.birthdate({ min: 18, max: 90, mode: 'age' }),
    gender: faker.helpers.arrayElement(Object.values(Gender)),
    riskStatus: faker.helpers.arrayElement(Object.values(RiskStatus)),
    consultationFrequency: faker.number.int({ min: 0, max: 12 }),
    associatedClaims: faker.lorem.words(3),
    createdAt: new Date(),
    updatedAt: new Date()
  };
}

export function generatePatients(count = 10) {
  return Array.from({ length: count }, generateRandomPatient);
}

