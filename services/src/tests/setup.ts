import mongoose from 'mongoose';
import { config } from '../config';

// Setup test database
beforeAll(async () => {
  // Use a separate test database
  const testDbUri = config.database.uri.replace(/l2l_\w+$/, 'l2l_test');

  await mongoose.connect(testDbUri, {
    serverSelectionTimeoutMS: 5000,
  });
});

// Cleanup after all tests
afterAll(async () => {
  await mongoose.disconnect();
});

// Clear database between tests
afterEach(async () => {
  const collections = mongoose.connection.collections;
  for (const key in collections) {
    await collections[key].deleteMany({});
  }
});
