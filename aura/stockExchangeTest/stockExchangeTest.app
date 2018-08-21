<aura:application controller="tempController">
    <!-- <c:stockMarketFeed /> -->
    <aura:attribute name="accounts" type="List" />
    <aura:handler name="init" value="{!this}" action="{!c.doInit}"/>

    <section id="StockTicker">
        <LightningStars:StockTicker />
        <div class="test">
            <aura:iteration items="{!v.accounts}" var="acc">
                <p class="oneAccount">name: {! acc.Name}<br />
                    symbol: {! not(empty(acc.LightningStars__Stock_symbol__c)) ? acc.LightningStars__Stock_symbol__c : 'NONE' }</p>
            </aura:iteration>
        </div>
    </section>
    
    <section id="oktana">
        <okty_stock:Stock />
        
    </section>
    
    
    
</aura:application>