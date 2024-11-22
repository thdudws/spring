console.log("Reply Module.........");

let replyService = (function(){

    //add start
    function add(reply, callback, error){
        console.log("reply.......");

        $.ajax({
            type : 'post',
            url : '/replies/new',
            data : JSON.stringify(reply), //js객체 -> json 변환
            contentType : "application/json; charset=utf-8",
            
            success : function(result, status, xhr){
                if(callback){
                    callback(result);
                }
            },  //성공
            error : function(xhr, status, er){
                if(error){
                    error(er);
                }
            }   //실패
        })
    } //add end

    //getList start
    function getList(param, callback, error){
        console.log("js getList...........");

        let bno = param.bno;
        let page = param.page || 1;
        
        console.log(bno, ", ", page);

        $.ajax({
            type : "get",
            url : "/replies/pages/" + bno + "/" + page,
            success : function(data, status, xhr){
                
                if(callback){
                	//console.log(data);
                	console.log(data.replyCnt);
                	console.log(data.list);
                	
                	//callback(data); 댓글 목록만 가져오는 경우
                    callback(data.replyCnt, data.list); //댓글 목록, 숫자를 가져오는 경우
                }
            },
            error : function(xhr, status, er){
                if(error){
                    error(er);
                }
            }
        });
    }
    //getList end

    //remove start
    function remove(rno, replyer, callback, error){

        $.ajax({
            type : 'delete',
            url : '/replies/' + rno,
            
            data : JSON.stringify({rno:rno, replyer:replyer}),
            
            contentType: "application/json; charset=utf-8",
            
            success : function(deleteResult, status, xhr){
                if(callback){
                    callback(deleteResult);
                }
            },
            error : function(xhr, status, er){
                if(error){
                    error(er);
                }
            }
        });

    }
    //remove end

    //update start

    function update(reply, callback, error){
        $.ajax({
            type : 'put',
            url : "/replies/" + reply.rno,
            data : JSON.stringify(reply),
            contentType : "application/json; charset=utf-8",
            success : function(result, status, xhr){
                if(callback){
                    callback(result);
                }
            },
            error : function(xhr, status, er){
                if(error){
                    error(er);
                }
            }
        });
    }

    //update end

    //get start

    function get(rno, callback, error){
        $.ajax({
            type : 'get',
            url : "/replies/" + rno,
            success : function(replyVO, status, xhr){
                if(callback){
                    callback(replyVO);
                }
            }, 
            error : function(xhr, status, er){
                if(error){
                    error(er);
                }
            }
        });
    };

    //get end

    //dispalyTime start 24시간이 지나면 날짜만 표시
    function dispalyTime(timeValue){
        let today = new Date();

        let gap = today.getTime() - timeValue;

        let dataObj = new Date(timeValue);
        let str = "";

        if(gap < (1000 * 60 * 60 * 24)){
            let hh = dataObj.getHours();
            let mi = dataObj.getMinutes();
            let ss = dataObj.getSeconds();

            return [ (hh > 9 ? '' : '0') + hh, ":", (mi > 9 ? '' : '0') + mi,
                ':', (ss > 9 ? '' : '0') + ss ].join('');
        }else {
            let yy = dataObj.getFullYear();
            let mm = dataObj.getMonth() + 1;    //1월 : 0+1
            let dd = dataObj.getDate();

            return [yy, '/', (mm > 9 ? '' : '0') + mm, '/',
                    (dd > 9 ? '' : '0') + dd ].join('');
        }
    };
    //dispalyTime end

    return {
        add : add,
        getList : getList,
        remove : remove,
        update : update,
        get : get,
        dispalyTime : dispalyTime
    };
})();