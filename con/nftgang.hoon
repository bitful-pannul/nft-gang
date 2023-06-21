::  account-abstracted nftDAO [UQ| DAO]
/+  *zig-sys-smart
/=  lib  /con/lib/nftgang
=,  lib
|_  =context
++  write
  |=  =action
  ^-  (quip call diff)
  ?:  ?=(%create -.action)
    ::  issue a new item for a new abtract nft-dao
    ::  no salt -- this contract creates a single grain.
    =/  =item
      :*  %&  (hash-data [this this town 0]:context)
          this.context
          this.context
          town.context
          0  %nftgang
          [collection.action threshold.action 0]
      ==
    `(result ~ item^~ ~ ~)
  =+  (need (scry-state our.action))
  =/  gang  (husk state - `this.context ~)
  ~>  %after-gang-husk
  ?-    -.action
      %validate
    ::  scry out collection supply
    =+  (need (scry-state collection.noun.gang))
    =/  supply  supply.noun:(husk nft-metadata - `nft-contract `nft-contract)
    ~>  %after-supply
    ?>  ?&  ~(apt py sigs.action)
            ~>  %after-apt
            :: threshold * supply is greater/equal to (lent sigs)  
            =-  (gte ~(wyt py sigs.action) -)
            (div (mul threshold.noun.gang supply) 100)
            ~>  %after-threshold
            (lte eth-block.context deadline.action)          
            ::  enforce that call is %execute to ourself
            =(contract.call.action this.context)
            =(p.calldata.call.action %execute)
        ==
    ::  
    ~>  %before-typed
    =/  =typed-message
      :+  this.context  execute-jold-hash
    ::  signing msg: [(list call) collection-id nonce deadline]
    :^    +.q.calldata.call.action 
        collection.noun.gang 
      +(nonce.noun.gang) 
    deadline.action
    ::  assert signatures are correct
    ?>  %+  levy  ~(tap py sigs.action)
        |=  [[=address =id] =sig]
        ?&  =((recover typed-message sig) address)
            ::  scry item-id, assert holder, source & metadata
            =+  (need (scry-state id))
            =/  item  (husk nft - `nft-contract `address)
            =(collection.noun.gang metadata.noun.item)
        ==
      ~>  %after-all
    [call.action^~ [~ ~ ~ ~]]
  ::
      %execute
    ?>  =(id.caller.context this.context)
    :-  calls.action
    (result [%& gang(nonce.noun +(nonce.noun.gang))]^~ ~ ~ ~)
  ::
      %set-threshold
    ?>  =(id.caller.context this.context)
    ::  threshold is a percentage @ud 0-100 of collection supply, > 0
    ?>  ?&  (gth new.action 0)
            (lth new.action 100)
        ==
    =.  threshold.noun.gang  new.action
    `(result [%&^gang]^~ ~ ~ ~)
  ==
::
++  read
  |=  =pith
  ~
--