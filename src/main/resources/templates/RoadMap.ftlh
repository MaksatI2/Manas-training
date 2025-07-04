<#macro breadcrumbs items>
    <nav aria-label="breadcrumb" class="mb-4">
        <div class="card shadow" style="border-radius: 10px; box-shadow: 0 4px 15px rgba(0,102,204,0.1);">
            <div class="card-header py-2" style="background: linear-gradient(135deg, var(--primary-blue), var(--dark-blue)); border-radius: 10px 10px 0 0; border-left: 4px solid var(--primary-blue);">
                <ol class="breadcrumb m-0">
                    <#list items as item>
                        <li class="breadcrumb-item <#if item?is_last>active</#if>" aria-current="<#if item?is_last>page</#if>">
                            <#if !item?is_last>
                                <a href="${item.url}" class="text-white" style="text-decoration: none; transition: all 0.3s ease;">
                                    ${item.label}
                                </a>
                            <#else>
                                <span class="text-white">${item.label}</span>
                            </#if>
                        </li>
                        <#if !item?is_last>
                            <li class="breadcrumb-item separator">
                                <i class="fas fa-angle-right text-white" style="font-size: 0.9rem;"></i>
                            </li>
                        </#if>
                    </#list>
                </ol>
            </div>
        </div>
    </nav>

    <style>
        :root {
            --primary-blue: #0066cc;
            --dark-blue: #003d7a;
            --white: #ffffff;
        }

        .breadcrumb {
            background: transparent;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            font-size: 1rem;
            font-weight: 500;
        }

        .breadcrumb-item a:hover {
            transform: translateY(-1px);
            text-decoration: underline;
            color: var(--white);
        }

        .breadcrumb-item.active span {
            font-weight: 600;
        }

        .breadcrumb-item.separator {
            display: flex;
            align-items: center;
            margin: 0 0.5rem;
        }

        @media (max-width: 768px) {
            .breadcrumb {
                font-size: 0.9rem;
            }

            .card-header {
                padding: 0.5rem 1rem;
            }

            .breadcrumb-item.separator {
                margin: 0 0.3rem;
            }
        }
    </style>
</#macro>