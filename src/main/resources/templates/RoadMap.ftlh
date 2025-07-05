<#macro breadcrumbs items>
    <nav aria-label="breadcrumb" class="mb-4">
        <div class="d-flex align-items-center px-4 py-2 shadow-sm"
             style="border-radius: 12px; background: linear-gradient(135deg, #0066cc, #003d7a); box-shadow: 0 2px 8px rgba(0, 102, 204, 0.15);">
            <ol class="breadcrumb mb-0 d-flex align-items-center flex-wrap" style="background: transparent;">
                <#list items as item>
                    <li class="breadcrumb-item <#if item?is_last>active</#if>" aria-current="<#if item?is_last>page</#if>"
                        style="color: white; font-weight: <#if item?is_last>600<#else>500</#if>; font-size: 1rem;">
                        <#if !item?is_last>
                            <a href="${item.url}" class="text-white text-decoration-none" style="transition: color 0.2s;">
                                ${item.label}
                            </a>
                        <#else>
                            ${item.label}
                        </#if>
                    </li>
                    <#if !item?is_last>
                        <li class="mx-2 text-white d-flex align-items-center" aria-hidden="true">
                            <svg width="10" height="10" viewBox="0 0 20 20" fill="none" xmlns="http://www.w3.org/2000/svg">
                                <path d="M7 5L12 10L7 15" stroke="white" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"/>
                            </svg>
                        </li>
                    </#if>
                </#list>
            </ol>
        </div>
    </nav>


    <style>
        @media (max-width: 768px) {
            .breadcrumb {
                font-size: 0.9rem;
            }
            .breadcrumb li {
                margin-bottom: 2px;
            }
        }
    </style>
</#macro>
