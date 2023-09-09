use rinha::parser::{parse_or_report, ParseError};
use std::fs::read_to_string;

#[rustler::nif]
fn parse_rinha(filename: &str) -> Result<String, String> {
    let content = read_to_string(filename).map_err(|e| e.to_string())?;
    let file = parse_or_report(filename, &content).map_err(|e: ParseError| e.to_string())?;
    let json = serde_json::to_string(&file).map_err(|e| e.to_string())?;

    Ok(json)
}

rustler::init!("Elixir.RinhaCompiler.RinhaParser", [parse_rinha]);
