use crate::ethereum::error::EthereumError;
use crate::utils;

use web3::signing::{recover, RecoveryError};
use web3::types::Recovery;

fn prefix_signed_message(message: &str) -> [u8; 32] {
    let message_with_prefix = web3::signing::keccak256(
        format!(
            "{}{}{}",
            "\x19Ethereum Signed Message:\n",
            message.len(),
            message
        )
        .as_bytes(),
    );

    message_with_prefix
}

// Ledger fucked up with their algorithm for signature recovery
// v value is 0 or 1 instead of 27 or 28.
// See: https://ethereum.stackexchange.com/questions/111610/how-do-ledger-hardware-wallet-signatures-differ-from-web3-eth-personal-sign/143677
fn apply_ledger_fix(recovery: &Recovery) -> Recovery {
    let v = match recovery.v {
        0 => 27,
        1 => 28,
        _ => recovery.v,
    };

    Recovery {
        message: recovery.message.clone(),
        r: recovery.r,
        s: recovery.s,
        v,
    }
}

pub(crate) fn recover_address(signature: &str, message: &str) -> Result<String, EthereumError> {
    let raw_signature = utils::hex_decode(signature)?;
    let prefixed_message = prefix_signed_message(message);

    let recovery = Recovery::from_raw_signature(prefixed_message, &raw_signature)
        .or(Err(EthereumError::ParseError))?;

    let adjusted_recovery = apply_ledger_fix(&recovery);

    let recovery_id = adjusted_recovery
        .recovery_id()
        .ok_or(EthereumError::InvalidSignature)?;

    let signer = recover(&prefixed_message, &raw_signature[..64], recovery_id);

    match signer {
        Ok(addr) => Ok(format!("{:02X?}", addr)),
        Err(RecoveryError::InvalidSignature) => Err(EthereumError::InvalidSignature),
        Err(RecoveryError::InvalidMessage) => Err(EthereumError::InvalidMessage),
    }
}
