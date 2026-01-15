/**
 * L2L (Link to Learn) - Main Entry Point
 *
 * This is the main entry point for the L2L backend service.
 * It initializes the Express server with all necessary middleware and routes.
 */

import 'dotenv/config';
import Server from './server';

// Start the server
const server = new Server();
server.start();

export default server;
