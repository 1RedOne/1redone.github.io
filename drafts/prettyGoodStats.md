https://tutorial.eyehunts.com/js/javascript-number-format-comma-html-format-number-thousands-separator/

Part of my migration from WordPress Series

<div class="card" style="padding-top:20px;">    
    <header class="card-header">
        <div class="card-header-title">Blog Stats</a>
    </header>
    
    <div class="card-content">
        <div class="content">            
            <div id='blogHits'></div>
            <!-- initial value at migration was 2,065,292 -->
            <Script>
var xhr = new XMLHttpRequest();
xhr.open("GET", "https://api.countapi.xyz/hit/foxdeployhits");
xhr.responseType = "json";
xhr.onload = function() {
    document.getElementById('blogHits').innerText = this.response.value.toLocaleString('en') + ' hits';
    console.log("total hits " + this.response.value.toLocaleString('en'));
}
xhr.send();

</Script>
<p></p>
        </div>        
    </div>    
</div>


irm "https://api.countapi.xyz/create?key=foxdeployhits&value=2065292"