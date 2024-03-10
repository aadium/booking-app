const express = require('express');
const admin = require('firebase-admin');
const verifyToken = require('../middlewares/verifyToken');

const serviceAccount = require('../../etc/secrets/project1-6c6fe-firebase-adminsdk-kar9s-93ea820673.json');

admin.initializeApp({
    credential: admin.credential.cert(serviceAccount)
});

const router = express.Router();

router.get('/getUsers', verifyToken, async (req, res) => {
    try {
        const listUsers = await admin.auth().listUsers();
        const users = listUsers.users.map(userRecord => userRecord.toJSON());
        res.status(200).json(users);
    } catch (error) {
        console.error('Error fetching users:', error);
        res.status(500).json({ error: 'Failed to fetch users' });
    }
});

router.get('/getUser/:uid', verifyToken, async (req, res) => {
    try {
        const uid = req.params.uid;
        const userRecord = await admin.auth().getUser(uid);
        res.status(200).json(userRecord);
    } catch (error) {
        console.error('Error fetching user:', error);
        res.status(404).json({ error: 'User not found' });
    }
});

router.get('/getAllAdminEmails', verifyToken, async (req, res) => {
    try {
        const listUsers = await admin.auth().listUsers();
        const users = listUsers.users.map(userRecord => userRecord.toJSON());
        const adminEmails = users.filter(user => user.customClaims && user.customClaims.role === 'admin').map(user => user.email);
        res.status(200).json(adminEmails);
    } catch (error) {
        console.error('Error fetching users:', error);
        res.status(500).json({ error: 'Failed to fetch users' });
    }
});

router.delete('/deleteUser/:uid', verifyToken, async (req, res) => {
    try {
        const uid = req.params.uid;
        await admin.auth().deleteUser(uid);
        res.status(200).json({ message: 'User deleted successfully' });
    } catch (error) {
        console.error('Error deleting user:', error);
        res.status(500).json({ error: 'Failed to delete user' });
    }
});

router.delete('/deleteUserByEmail', verifyToken, async (req, res) => {
    try {
        const email = req.body.email;
        const user = await admin.auth().getUserByEmail(email);
        await admin.auth().deleteUser(user.uid);
        res.status(200).json({ message: 'User deleted successfully' });
    } catch (error) {
        console.error('Error deleting user:', error);
        res.status(500).json({ error: 'Failed to delete user' });
    }
});

router.post('/createUser', verifyToken, async (req, res) => {
    try {
        const { email, password, role } = req.body;
        if (role) {
            const userRecord = await admin.auth().createUser({
                email,
                password
            });
            await admin.auth().setCustomUserClaims(userRecord.uid, { role });
            res.status(201).json(userRecord);
        } else {
            const userRecord = await admin.auth().createUser({
                email,
                password
            });
            res.status(201).json(userRecord);
        }
    } catch (error) {
        console.error('Error creating user:', error);
        res.status(500).json({ error: 'Failed to create user' });
    }
});

module.exports = router;