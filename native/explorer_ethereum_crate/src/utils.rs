use crate::ethereum::error::EthereumError;

pub(crate) fn hex_decode(data: &str) -> Result<Vec<u8>, EthereumError> {
    hex::decode(data.trim_start_matches("0x")).or(Err(EthereumError::ParseError))
}
