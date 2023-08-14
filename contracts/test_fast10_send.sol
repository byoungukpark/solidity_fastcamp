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


//@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
//보낼때 : call, send, transfer
//받을때 : payable, receive, fallback

contract bank01{
    mapping (address => uint) public balance;
    event log(bytes data);

    function deposit() public payable returns(uint){
        balance[msg.sender] += msg.value;
        return msg.value;
    }

    //주소 와 자산 총량을 인자로 받는 함수
    function withdrawbycall(address payable _addr, uint _amount) public {//인출 - 보내기 
        //자산이 부족하면 실행되는 경고문
        require(balance[msg.sender] > _amount, "no money"); //require안의 조건문이 true 가 되면 실행
        //해당 자산을 기록
        balance[msg.sender] -= _amount;
        //무사히 콜을 하면 sucess가 true가 된다.
        (bool sucess, bytes memory data) = _addr.call{value: _amount}("");
        
        //해당 기록을 출력
        emit log(data);
        require(sucess,"faile"); //실패 했으면 종료
    }

    function withdrawbysend(address payable _addr, uint _amount) public {//인출 - 보내기 
        //자산이 부족하면 실행되는 경고문
        require(balance[msg.sender] > _amount, "no money"); //require안의 조건문이 true 가 되면 실행
        //해당 자산을 기록
        balance[msg.sender] -= _amount;
        
        //무사히 콜을 하면 sucess가 true가 된다.
        (bool sucess) = _addr.send(_amount);
        
        require(sucess,"faile"); //실패 했으면 종료
    }
    //call, send 는 전송 실패시에 롤백이 되지 않기에 복구가 안될수 있다. 
    //require를 각 함수에 추가하여 버그를 잡는다 - require는 호출시 롤백이 된다

    function withdrawbytransfer(address payable _addr, uint _amount) public {//인출 -  보내기 
        //자산이 부족하면 실행되는 경고문
        require(balance[msg.sender] > _amount, "no money"); //require안의 조건문이 true 가 되면 실행
        //해당 자산을 기록
        balance[msg.sender] -= _amount;
        
        //보내는 방법중 가장 안전한 방법
        _addr.transfer(_amount);
    }// 실패시에 모든 과정이 롤백 되기에 가장 안전한 방법이다


    //나의 자산을 가져오기
    function getbalance() public view returns(uint){
        return balance[msg.sender];
    }

}
