//import TeleRacingPreSale from 0x09568b29f07c5f87

import TeleRacingPreSale from "../contracts/TeleRacingPreSale.cdc"

pub fun main(): UInt64 {
    return TeleRacingPreSale.totalSupply
}