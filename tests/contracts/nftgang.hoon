::  
::  tests for con/nftgang.hoon
::  account abstraction!
/+  *test, *transaction-sim, bip32
/=  gang-lib  /con/lib/nftgang
/*  gang-contract  %jam  /con/compiled/nftgang/jam
/*  nft-contract  %jam  /con/compiled/nft/jam
|%
::
::  test data
::
++  sequencer  caller-1
++  caller-1  ^-  caller:smart  [addr-1 1 (id addr-1)]:zigs
++  caller-2  ^-  caller:smart  [addr-2 1 (id addr-2)]:zigs
++  caller-3  ^-  caller:smart  [addr-3 1 (id addr-3)]:zigs
++  caller-4  ^-  caller:smart  [addr-4 1 (id addr-4)]:zigs
::
++  nft
  |%
  ++  code
    (cue nft-contract)
  ++  id
    (hash-pact 0x1234.5678 0x1234.5678 default-town-id code)
  ++  pact
    ^-  item:smart
    :*  %|  id
        0x1234.5678  ::  source
        0x1234.5678  ::  holder
        default-town-id
        [- +]:code
        ~
    ==
  --
::
++  gang
  |%
  ++  code
    (cue gang-contract)
  ++  item-id  
    (hash-data id.p:pact id.p:pact default-town-id 0)
  ++  pact
    ^-  item:smart
    :*  %|  (hash-pact:smart 0x1234.5678 0x1234.5678 default-town-id code)
        0x1234.5678  ::  source
        0x1234.5678  ::  holder
        default-town-id
        [- +]:code
        ~
    ==
  ++  uninitialized-pact
    ^-  item:smart
    :*  %|  (hash-pact 0xdead.beef 0xdead.beef default-town-id code)
        0xdead.beef  ::  source
        0xdead.beef  ::  holder
        default-town-id
        [- +]:code
        ~
    ==
  ++  our
    |=  =state:gang-lib
    ^-  item:smart
    :*  %&  item-id
        id.p:pact
        id.p:pact
        default-town-id
        0  %nftgang
        state
    ==
  --
::
++  gang-1
  |%
  ++  salt
    (cat 3 'test-salt' addr-1:zigs)
  ++  metadata
    ^-  item:smart
    :*  %&
        (hash-data id:nft id:nft default-town-id salt)
        id:nft
        id:nft
        default-town-id
        salt
        %metadata
        :*  name='gang-1'
            symbol='G1'
            properties=~
            supply=4
            cap=~
            mintable=%.y
            minters=[addr-1:zigs ~ ~]
            deployer=addr-1:zigs
            salt
    ==  ==
  ++  item-1
    ^-  item:smart
    :*  %&
        (hash-data id:nft addr-1:zigs default-town-id (cat 3 salt 1))
        id:nft
        addr-1:zigs
        default-town-id
        (cat 3 salt 1)
        %nft
        :*  1
            'first'
            id.p:metadata
            allowances=[addr-2:zigs ~ ~]
            properties=~
            transferrable=%.y
    ==  ==
  ++  item-2
    ^-  item:smart
    :*  %&
        (hash-data id:nft addr-2:zigs default-town-id (cat 3 salt 2))
        id:nft
        addr-2:zigs
        default-town-id
        (cat 3 salt 2)
        %nft
        :*  2
            'second'
            id.p:metadata
            allowances=[addr-1:zigs ~ ~]
            properties=~
            transferrable=%.y
    ==  ==
  ++  item-3
    ^-  item:smart
    :*  %&
        (hash-data id:nft addr-3:zigs default-town-id (cat 3 salt 3))
        id:nft
        addr-3:zigs
        default-town-id
        (cat 3 salt 3)
        %nft
        :*  3
            'third'
            id.p:metadata
            allowances=~
            properties=~
            transferrable=%.y
    ==  ==
  ++  item-4
    ^-  item:smart
    :*  %&
        (hash-data id:nft addr-4:zigs default-town-id (cat 3 salt 4))
        id:nft
        addr-4:zigs
        default-town-id
        (cat 3 salt 4)
        %nft
        :*  4
            'fourth'
            id.p:metadata
            allowances=~
            properties=~
            transferrable=%.y
    ==  ==
  --
::
++  state
  %-  make-chain-state
  :~  pact:gang
      ::  uninitialized-pact:gang
      (our:gang [id.p:metadata:gang-1 2 5])
      (account:zigs id.p:pact:gang 1.000.000 ~)
      pact:nft
      metadata:gang-1
      item-1:gang-1
      item-2:gang-1
      item-3:gang-1
      item-4:gang-1
      pact:zigs
      (account addr-1 300.000.000 [addr-2 1.000.000]^~):zigs
      (account addr-2 200.000.000 ~):zigs
      (account addr-3 100.000.000 [addr-1 50.000]^~):zigs
      (account addr-4 500.000 ~):zigs
  ==
++  chain
  ^-  chain:engine
  [state ~]
::
++  get-signed-transaction
  |=  calls=(list call:smart)
  ^-  transaction:smart
  ~&  "zigs pact: {<id.p:pact:zigs>}"
  ~&  "zigs: accout {<(account:zigs id.p:pact:zigs 1.000.000 ~)>}"
  =/  my-call=call:smart
    :+  id.p:pact:gang
      0x0
    :+  %execute
      item-id:gang
    calls
  =/  =typed-message:smart
    :+  id.p:pact:gang                     :: domain
      execute-jold-hash:gang-lib           :: type-hash
    :^    calls                            :: msg: [(list call) collection nonce deadline]
        id.p:metadata:gang-1
      nonce=6
    deadline=1.000
  =/  hash  `@uvI`(shag:smart typed-message)
  :+  fake-sig
    :*  %validate
        item-id:gang
        ::  sig map
        %-  make-pmap:smart
        :~  :-  [addr-1:zigs id.p:item-1:gang-1]
            %+  ecdsa-raw-sign:secp256k1:secp:crypto
            hash  priv-1:zigs
            :-  [addr-2:zigs id.p:item-2:gang-1]
            %+  ecdsa-raw-sign:secp256k1:secp:crypto
            hash  priv-2:zigs
            :-  [addr-3:zigs id.p:item-3:gang-1]
            %+  ecdsa-raw-sign:secp256k1:secp:crypto
            hash  priv-3:zigs
        ==
        deadline=1.000
        my-call
    ==
  [*caller:smart ~ id.p:pact:gang [1 30.000] default-town-id 0]
::
::  tests for %give
::
++  test-zz-basic-give  ^-  test-txn
  =/  tx
    %-  get-signed-transaction
    ^-  (list call:smart)
    :_  ~                              
    :+  id.p:pact:zigs  0x0
    [%give 0xdead.beef 500.000 (id:zigs id.p:pact:gang)]
 :^    chain
     [sequencer default-town-id batch=1 eth-block-height=999]
   tx
 :*  gas=~
     errorcode=`%0
     ::  assert correct modified state
     :-  ~
     %-  make-chain-state
     :~  (account:zigs id.p:pact:gang 500.000 ~)
         (account 0xdead.beef 500.000 ~):zigs
         (our:gang [id.p:metadata:gang-1 2 6])
     ==
     burned=`~
     events=`~
 ==
::
::  ++  test-zz-zigs-give  ^-  test-txn
::    =/  =calldata:smart
::      [%give addr-2:zigs 1.000 (id addr-1):zigs]
::    =/  tx=transaction:smart  
::      :+  fake-sig 
::        calldata
::      [caller-1 ~ id.p:pact:zigs [1 200.000] default-town-id 0]
::    :^    chain
::        [sequencer default-town-id batch=1 eth-block-height=0]
::      tx
::    :*  gas=~  ::  we don't care
::        errorcode=`%0
::        ::  assert correct modified state
::        :-  ~
::        %-  make-chain-state
::        :~  (account addr-1 299.999.000 [addr-2 1.000.000]^~):zigs
::            (account addr-2 200.001.000 ~):zigs
::        ==
::        burned=`~
::        events=`~
::    ==
::  ++  test-zz  ^-  test-txn
::    :^  chain
::      [sequencer default-town-id batch=1 eth-block-height=0]
::    [caller-1 ~ id.p:pact:zigs [1 1.000.000] default-town-id 0]
::    :*  gas=~  ::  we don't care
::        errorcode=`%0
::        ::  assert correct modified state
::        ~
::        burned=`~
::        events=`~
::    ==
::  ++  test-zzz-create-many-members  ^-  test-txn
::    =/  member-set  (make-pset:smart ~[0xdead 0xbeef 0xcafe 0xbabe])
::    =/  =calldata:smart  [%create 3 member-set]
::    =/  tx=transaction:smart  [fake-sig calldata create-shell]
::    ::
::    =*  con-id  id.p:uninitialized-pact:multisig
::    =/  output-item      
::      ^-  item:smart
::      :*  %&  (hash-data:smart con-id con-id default-town-id 0)
::          con-id
::          con-id
::          default-town-id
::          0  %multisig
::          [member-set 3 0]
::      ==
::    :^    chain
::        [sequencer default-town-id batch=1 eth-block-height=0]
::      tx
::    :*  gas=~
::        errorcode=`%0
::        ::  modified
::        :-  ~
::        %-  make-chain-state
::        :~
::          output-item
::        == 
::        burned=`~
::        events=`~
::    ==
--