const mysql = require('mysql2');
const config = require('./config');
const path = require('path');
const fs = require('fs');

function initializeDatabase(maxRetries = 10, initialDelay = 1000) {
    return new Promise((resolve, reject) => {
        let retryCount = 0;

        function attemptConnection() {
            const connection = mysql.createConnection({
                host: config.APP_DB_HOST,
                user: config.APP_DB_USER,
                password: config.APP_DB_PASSWORD,
                multipleStatements: true,
                connectTimeout: 10000,
                // Add this parameter
                enableKeepAlive: true
            });

            console.log(`Connecting to MySQL server... (Attempt ${retryCount + 1}/${maxRetries})`);

            connection.connect((err) => {
                if (err) {
                    // Don't call connection.end() here
                    if ((err.code === 'ECONNREFUSED' || err.code === 'ETIMEDOUT') && retryCount < maxRetries) {
                        retryCount++;
                        const delay = initialDelay * Math.pow(2, retryCount - 1);
                        console.log(`Connection failed: ${err.message}. Retrying in ${delay}ms...`);
                        setTimeout(attemptConnection, delay);
                        return;
                    }
                    console.error('Maximum connection attempts reached:', err);
                    reject(err);
                    return;
                }

                console.log('Connected to MySQL server. Reading SQL initialization script...');
                const sqlFilePath = path.join(__dirname, 'init.sql');
                const sqlScript = fs.readFileSync(sqlFilePath, 'utf8');

                console.log('Executing SQL initialization script...');
                connection.query(sqlScript, (err, results) => {
                    if (err) {
                        console.error('Error executing SQL script:', err);
                        // Safely close the connection
                        safelyCloseConnection(connection, () => reject(err));
                    } else {
                        console.log('Database initialized successfully!');
                        // Safely close the connection
                        safelyCloseConnection(connection, () => resolve(results));
                    }
                });
            });
        }

        // Helper function to safely close connections
        function safelyCloseConnection(connection, callback) {
            try {
                if (connection && connection.state !== 'disconnected') {
                    connection.end(err => {
                        if (err) {
                            console.error('Error closing connection:', err);
                        } else {
                            console.log('MySQL connection closed successfully.');
                        }
                        if (callback) callback();
                    });
                } else {
                    if (callback) callback();
                }
            } catch (error) {
                console.error('Exception while closing connection:', error);
                if (callback) callback();
            }
        }

        attemptConnection();
    });
}

module.exports = { initializeDatabase };
