<aura:application extends="force:slds" implements="force:appHostable,flexipage:availableForAllPageTypes,forceCommunity:availableForAllPageTypes">
    <!--
        https://jmalenfant-dev-ed.lightning.force.com/c/show.app
    -->
    <!-- a <div> "container" that contains all others and that gets the class "cShow" -->
    <div>
        <div class="exo1-app-container">

            <div class="slds-grid slds-gutters_small">
                <div class="slds-col slds-size_1-of-6"></div>
                <div class="slds-col slds-size_1-of-3">
                    <c:exo01_AccountList withPagination="true" />

                    <c:exo01_pagination listName="AccountList" />
                </div>
                <div class="slds-col slds-size_1-of-3">
                    <c:exo01_ContactList withPagination="true" />
                    
                    <!-- not fully implemented for contacts -->
                    <!--c:exo01_pagination listName="ContactList" /-->
                </div>
                <div class="slds-col slds-size_1-of-6"></div>
            </div>
        </div>
    </div>
</aura:application>