import mongoose from 'mongoose';

const MONGO_URI = 'mongodb+srv://pedromra04:aTlp5xKAnEhbZhaJ@banco-aletheia.g4z12nh.mongodb.net/?retryWrites=true&w=majority&appName=Banco-Aletheia'; 

export default async function connectToDatabase(): Promise<void> {
  try {
    await mongoose.connect(MONGO_URI);
    console.log('✅ Conectado ao MongoDB');
  } catch (error) {
    console.error('❌ Erro ao conectar ao MongoDB:', error);
    process.exit(1);
  }
}
