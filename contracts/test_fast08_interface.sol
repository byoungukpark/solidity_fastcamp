// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

/*
추상화 : 같이 묶는것

추상 컨트렉트 : abstract 키워드 사용, 부모 - 상속받아 사용
ex) abstract contract system{}
컨트렉트 내부에 추상함수가 있으면 대부분 추상 컨트렉트


인터페이스 / interface : 스마트 계약에서의 뼈대, 부모 - 상속받아 사용
함수의 가시성 지정자는 external 이여야 함
생성자 정의 x , 변수 정의 x, 모디파이어(view, pure) x


예외처리 함수들 : assert, revert, require, try/catch

assert(bool 문- 오류발생 조건){}
: 이 assert 는 revert를 사용해 가스비 환불 가능
내부 오류를 테스트 하고 불변성을 확인하는데 사용

revert("오류 발생 이유") : 이 문이 살행되면 무조건 오류처리이기에 if문과 함께 사용
오류를 발생시키고 오류 발생이유를 출력시켜 준다.
revert에서 오류 발생시 가스비를 환불해준다.
ex) if(a<10) {revert("error")}

require(오류 발생 조건(false일대 발생), "오류 메시지")
ex) require(n > 10, "error")

try/catch : 오류 발생해도 트랜젝션이 중지 되지 않음, 하지만 catch에서 오류 발생시 종료

정리 >
오류처리 : assert, revert, require
예외처리 : try/ catch

*/

contract Error_01{
    function testrevert(uint i) public pure{
        if(i <= 10 ){
            revert("i is to small, must up 10");
        }
    }

    function testrequire(uint i) public pure{
        require(i > 10, "error 10"); //조건에 부합해야 실행 안됨
    }

    uint public num;

    function testassert() public view{
        assert(num == 0);
    }

    //커스텀
    error insuffballnce(uint ballnce, uint widthrow);

    function testcoustum(uint _widthrow) public view{
        uint bal = address(this).balance;
        if(bal < _widthrow){
            revert insuffballnce({ballnce: bal, widthrow : _widthrow});
        }
    }

}


contract adult{
    uint public age;
    constructor(uint _age){
        require(_age > 19, "error");
        age = _age;
    }
}

contract catcherror{
    event informatoin(string _error);

    function testtrycatch(uint _age) public returns(uint){
        try new adult(_age) returns(adult ad){
            emit informatoin("sses");
            return(ad.age());
        }catch {
            emit informatoin("fale");
            adult ad = new adult(20);
            return(ad.age());
        }
    }
}
