users = %{
  "0xb7a000c543aC7E39fDf4fC391B3900078E070325" => 11,
  "0x1eF94BEa1542da6d61c68f26f7a3933A240C87bD" => 12,
  "0x710DD7f6e3e47Ddc08fac4795694d7ec4506C4e6" => 13
}

for {eth_address, seller_id} <- users do
  Explorer.Accounts.create_user(%{
    eth_address: eth_address,
    reputable_seller_id: seller_id
  })
end
