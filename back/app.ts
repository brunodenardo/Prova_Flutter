import express, { Request, Response } from 'express';
import gerarToken from './src/geraToken';
import { notaAlunos } from './src/notasAlunos';
import corsModules from 'cors'

const app = express();

app.use(corsModules());

const port: number = 3000;

app.get('/login', (req: Request, res: Response) => {
  res.send({data:{token:gerarToken("123456")}});
});

app.get('/notasAlunos', (req: Request, res: Response) => {
  res.send({data:notaAlunos})
})

app.listen(port, () => {
  // Log a message when the server is successfully running
  console.log(`Server is running on http://localhost:${port}`);
});

function cors(arg0: {
  origin: string; // Permitir requisições deste domínio
}): any {
  throw new Error('Function not implemented.');
}
