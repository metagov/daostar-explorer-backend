use rustler::{Env, Term};

mod atoms {
    rustler::atoms! {
        invalid_message,
        invalid_signature,
        parse_error,
    }
}

#[derive(Debug)]
pub enum EthereumError {
    InvalidMessage,
    InvalidSignature,
    ParseError,
}

impl rustler::types::Encoder for EthereumError {
    fn encode<'b>(&self, env: Env<'b>) -> Term<'b> {
        let atom = match self {
            EthereumError::InvalidMessage => atoms::invalid_message(),
            EthereumError::InvalidSignature => atoms::invalid_signature(),
            EthereumError::ParseError => atoms::parse_error(),
        };

        atom.encode(env)
    }
}
