/+  *zig-sys-smart
|%
+$  state
  [collection=id threshold=@ud nonce=@ud]
::
+$  action
  $%  
      [%create collection=id threshold=@ud]
      [%validate our=id sigs=(pmap [address id] sig) deadline=@ud =call]
      [%execute our=id calls=(list call)]
      [%set-threshold our=id new=@ud]
  ==
::
+$  nft-metadata
    $:  name=@t
        symbol=@t
        properties=(pset @tas)
        supply=@ud
        cap=(unit @ud)  ::  (~ if no cap)
        mintable=?      ::  automatically set to %.n if supply == cap
        minters=(pset address)
        deployer=id
        salt=@
    ==
::
++  nft-contract       0xc7ac.2b08.6748.221b.8628.3813.5875.3579.01d9.2bbe.e6e8.d385.f8c3.b801.84fc.00ae
++  execute-jold-hash  0x3f7b.2196.c694.57bd.a4f6.3120.3122.bd5d
::
::  ^-  @ux
::  %-  sham
::  %-  need
::  %-  de-json:html
::  ^-  cord
::  '''
::  [
::    {"calls": [
::      "list",
::      [
::        {"contract": "ux"},
::        {"town": "ux"},
::        {"calldata": [{"p": "tas"}, {"q": "*"}]}
::      ]
::    ]},
::    {"collection": "ux"},
::    {"nonce": "ud"},
::    {"deadline": "ud"}
::  ]
::  '''
--