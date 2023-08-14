// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

/*
1) 이더리움 계정
EOA : 메타마스크, 외부소유 계정 - 암호화폐 지갑을 통해 가능
CA : 배포시 생성, 트렌젝션을 준사람의 주소- 직접 트랜잭션을 발생 시키지 못함 외부의 계정에서 접근하여 실행됨

Global 
payable : 이더를 받으려면 꼭 필요한 함수
Msg.sender Adress 타입
Msg.value : 전송 금액
address.ballnce : 계좌 잔액 

withdraw : 인출
Deposit : 예치?


2) 이더 송금을 위한 함수 = 이더를 보내는 3가지 방법: send, transfer, call
payable (함수, 주소, 생성자에 붙여서 사용)
send : 2300 가스 소비, 성공여부를 반환함
transfer : 2300가스 소비, 실패시 애러 발생
call : 특정함수 호출, 이더 전송도 가능,  성공여부를 반환함, 재진입 공격 위험성???


3) 이더를 받는 방법 : payable, receiver, fallback
payable : 함수를 호출할때 이더를 함께 송금
receiver : 컨트랙트별 최대 하나의 이더 수신 함수 receive 허용 
fallback : 함수 호출조건이 만족되지 않을 경우 호출 되는 함수

*/

contract testtransfer{
    function fetbalance(address adr) public view returns(uint){
        return adr.balance; //계좌의 현제 잔약 양
    }

    function getmsgvalue() public payable returns(uint){
        return msg.value; //토큰을 얼마나 받았는지, 전송 금액?
    }
}

contract testreceive{ // 받기
    receive() external payable {}
    fallback() external payable {}
    function getbalance() public view returns(uint){
        return address(this).balance;
    }
}

contract test_send{ //보내기
    function sendto(address payable _to) public payable{
        _to.transfer(msg.value);
    } 

    function sendandreturn(address payable _to) public payable {
        bool sent = _to.send(msg.value);
        require(sent, "faile");
    }
    // function sendcall(address payable _to) public payable {
    //     (bool sent, bytes memory data) = _to.call{value: msg.value}("");
    //     require(sent, "fail");
    // }

}

