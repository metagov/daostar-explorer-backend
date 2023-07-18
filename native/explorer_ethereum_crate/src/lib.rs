mod ethereum;
mod utils;

use ethereum::error::EthereumError;

#[rustler::nif]
fn recover_address(signature: String, message: String) -> Result<String, EthereumError> {
    ethereum::wallet::recover_address(&signature, &message)
}

rustler::init!("Elixir.Explorer.Crypto.Ethereum.Crate", [recover_address]);
