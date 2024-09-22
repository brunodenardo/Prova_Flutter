import jwt from 'jsonwebtoken';

const SECRET_KEY = 'minha-chave-secreta';

// Função para gerar o token
const gerarToken = (usuarioId: string): string => {

  const payload = {
    id: usuarioId,
    nome: 'Bruno Denardo',
    role: 'admin'
  };

  const options = {
    expiresIn: '1h'
  };

  const token = jwt.sign(payload, SECRET_KEY, options);
  
  return token;
};


export default gerarToken