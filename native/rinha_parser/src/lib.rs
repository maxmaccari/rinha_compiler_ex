#[rustler::nif]
fn parse_rinha(content: &str) -> String {
    format!("Testing {content}...").to_owned()
}

rustler::init!("Elixir.RinhaCompiler.RinhaParser", [parse_rinha]);
