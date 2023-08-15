// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

//랜덤 수를 발생 시키는 컨트렉트
contract Random{
    //event : 로그 출력용 양식
    event paidaddress(address indexed sender, uint256 payment);
    event winneraddress(address indexed winner);

    //모디파이어 : 모든 함수 실행전과 후에 실행될 코드
    //_; 이거 기준으로 위 : 함수 실행전 실행, 아래 : 함수 실행 후 실행됨
    //배포자만 실행 가능한 함수(모디파이어 함수 제한)
    modifier onlyowner(){
        require(msg.sender == owner, "call is not owner");
        _; 
    }

    mapping (uint256 => mapping(address => bool)) public paidaddress_list;
    address public owner;
    string private key1;
    uint private key2;
    uint private winnernumber = 0;

    uint public round = 1;
    uint public playnumber = 0;

    //컨트랙트 생성자
    constructor(string memory _key1, uint256 _key2){
        owner = msg.sender;
        key1 = _key1;
        key2 = _key2;
        winnernumber = 1;
    }

    //receive : 순수하게 이더만 받을때 사용하는 함수, external payble 필수
    //msg.sender : 현재 스마트 계약을 호출한 계정의 주소

    receive() external payable {
        require(msg.value == 10**16, "must be 0.01eth");
        require(paidaddress_list[round][msg.sender] == false, "rount chance is only one");
        paidaddress_list[round][msg.sender] = true;
        playnumber++;

        if(playnumber == winnernumber){ //해당 플레이어가 승리자일 경우
            (bool sucesses,) = msg.sender.call{value: address(this).balance}(""); //이게 계좌에서 가져오걸까?
            require(sucesses, "failed");
            playnumber = 0;
            round++;
            //winnernumber = randomnumber();
            emit winneraddress(msg.sender);
        }else{
            emit paidaddress(msg.sender, msg.value);
        }


    }

    function randonnumber() public view returns (uint){
        uint num = uint(keccak256(abi.encode(key1))) + key2 + (block.timestamp) + (block.number);
        return (num - ((num/10)*10))+1;
    }

    function setsecretkey(string memory _key1, uint _key2) public onlyowner(){
        key1 = _key1;
        key2 = _key2;
    }

    function getsecretkey() public view onlyowner() returns(string memory, uint){
        return (key1,key2);
    }

    function getwinnernumber() public view onlyowner() returns(uint256){
        return (winnernumber);
    }

    function getround() public view returns(uint256){
        return round;
    }

    function getbalance() public view returns(uint256){
        return address(this).balance;
    }

}