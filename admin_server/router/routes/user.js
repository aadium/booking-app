const express = require('express');
const admin = require('firebase-admin');

const serviceAccount = require('./project1-6c6fe-firebase-adminsdk-kar9s-93ea820673.json');
admin.initializeApp({
    credential: admin.credential.cert(serviceAccount)
});

const router = express.Router();

router.get('/', async (req, res) => {
    try {
        const listUsers = await admin.auth().listUsers();
        const users = listUsers.users.map(userRecord => userRecord.toJSON());
        res.status(200).json({ users });
    } catch (error) {
        console.error('Error fetching users:', error);
        res.status(500).json({ error: 'Failed to fetch users' });
    }
});

router.post('/', async (req, res) => {
    try {
        const { email, password, role } = req.body;
        if (role) {
            const userRecord = await admin.auth().createUser({
                email,
                password
            });
            await admin.auth().setCustomUserClaims(userRecord.uid, { role });
            res.status(201).json({ message: 'User created successfully', userRecord });
        } else {
            const userRecord = await admin.auth().createUser({
                email,
                password
            });
            res.status(201).json({ message: 'User created successfully', userRecord });
        }
    } catch (error) {
        console.error('Error creating user:', error);
        res.status(500).json({ error: 'Failed to create user' });
    }
});

router.get('/:uid', async (req, res) => {
    try {
        const uid = req.params.uid;
        const userRecord = await admin.auth().getUser(uid);
        res.status(200).json({ userRecord });
    } catch (error) {
        console.error('Error fetching user:', error);
        res.status(404).json({ error: 'User not found' });
    }
});

router.delete('/:uid', async (req, res) => {
    try {
        const uid = req.params.uid;
        await admin.auth().deleteUser(uid);
        res.status(200).json({ message: 'User deleted successfully' });
    } catch (error) {
        console.error('Error deleting user:', error);
        res.status(500).json({ error: 'Failed to delete user' });
    }
});

module.exports = router;