import express, { Request, Response } from 'express';
import * as _ from 'lodash';

const app = express();
app.use(express.json());

// VULNERABILITY 1: Hardcoded Secret (Target for GitLeaks)
const AWS_PROD_KEY = "AKIAIOSFODNN7EXAMPLE";

app.get('/api/health', (req: Request, res: Response) => {
    res.status(200).json({ status: "API is running", key: AWS_PROD_KEY });
});

// VULNERABILITY 2: Insecure Code Pattern (Target for Semgrep)
// Taking raw user input and executing it directly via eval() is highly dangerous
app.post('/api/calculate', (req: Request, res: Response) => {
    const userInput = req.body.equation;
    try {
        const result = eval(userInput); 
        res.status(200).json({ result: result });
    } catch (error) {
        res.status(500).json({ error: "Calculation failed" });
    }
});

// VULNERABILITY 3: Outdated Dependency (Target for Snyk)
// We installed lodash 4.17.15, which has a known Prototype Pollution vulnerability
app.post('/api/merge', (req: Request, res: Response) => {
    const payload = req.body;
    const targetObject = {};
    
    // Using the vulnerable lodash merge function
    _.merge(targetObject, payload);
    
    res.status(200).json({ message: "Object merged successfully", data: targetObject });
});

const PORT = 3000;
app.listen(PORT, () => {
    console.log(`Vulnerable API running on port ${PORT}`);
});
