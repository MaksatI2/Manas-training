<#import "/spring.ftl" as spring />
<#include "../layout.ftlh">
<@page>
    <h1 class="text-center mt-4 mb-5">Загрузка изображения</h1>
    <div class="w-50 mx-auto">
        <form method="post" action="/image/upload" enctype="multipart/form-data">
            <div class="input-group mb-3">
                <input type="file" class="form-control" id="image" name="image">
                <label class="input-group-text" for="image">Изображение пользователя</label>
            </div>
            <#if _csrf??>
                <input type="hidden" name="${(_csrf.parameterName)!'csrf-param-name'}"
                       value="${(_csrf.token)!'csrf-token'}"/>
            </#if>
            <input type="hidden" name="userId" value="${userId}">
            <div class="text-center mt-5">
                <button type="submit" class="btn btn-primary fs-4 px-5 py-3">Сохранить</button>
            </div>
        </form>
    </div>
</@page>