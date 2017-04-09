macro_attr!(
    #[derive(Eq, PartialEq, Clone, Debug, EnumFromStr!)]
    pub enum Feature {
        Door,
        UpStair,
        DownStair,
    }
);

macro_attr!(
    #[derive(Eq, PartialEq, Copy, Clone, Debug, EnumFromStr!)]
    pub enum Terrain {
        Wall,
        Floor,
        Important,
        Nothing,
    }
);

impl Terrain {
    pub fn to_char(&self) -> char {
        match *self {
            Terrain::Wall => '#',
            Terrain::Floor => '.',
            Terrain::Important => '$',
            Terrain::Nothing => ' ',
        }
    }

    pub fn is_blocking(&self) -> bool {
        match *self {
            Terrain::Wall | Terrain::Nothing => true,
            _             => false,
        }
    }
}
