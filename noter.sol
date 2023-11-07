// SPDX-License-Identifier: MIT

pragma solidity ^0.8.2;

contract Noter {
    struct EvIlani {
        uint id;
        uint m2;
        uint price;
        string location;
        address sahip;
        address alici;
        bool sahipOnay;
        bool aliciOnay;
        bool sonDurum;
        bool paraCekimi;
    }

    uint public id = 0;
    mapping(uint => EvIlani) public ilanlar;

    function evAl(uint _id) public payable {
        EvIlani storage evIlani = ilanlar[_id];

        require(evIlani.sahip != msg.sender);
        require(evIlani.price <= msg.value);

        evIlani.alici = msg.sender;
    }

    function eviSat(uint _m2, uint _price, string memory _location) public {
        EvIlani memory evIlani = EvIlani({
            id: id, 
            m2: _m2,
            price: _price,
            location: _location,
            sahip: msg.sender,
            alici: msg.sender,
            sahipOnay: false,
            aliciOnay: false,
            sonDurum: false,
            paraCekimi: false
            });
        ilanlar[id] = evIlani;
        id++;

        evIlani.sahip = msg.sender;
    }

    function onayla(uint _id) public {
        EvIlani storage evIlani = ilanlar[_id];

        require(evIlani.sahip != evIlani.alici);
        require(msg.sender == evIlani.sahip || msg.sender == evIlani.alici);
        
        if (msg.sender == evIlani.sahip) {
            evIlani.sahipOnay = true;
        } else if (msg.sender == evIlani.alici) {
            evIlani.aliciOnay = true;
        }

        if (evIlani.aliciOnay == true && evIlani.sahipOnay == true) {
            evIlani.sonDurum = true;
        }
    }

    function paraCek(uint _id) public {
        EvIlani storage evIlani = ilanlar[_id];

        require(evIlani.sahip == msg.sender);
        require(evIlani.sonDurum == true);

        payable(evIlani.sahip).transfer(evIlani.price);

    }
}