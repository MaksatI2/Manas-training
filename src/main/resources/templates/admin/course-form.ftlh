<#import "../layout.ftlh" as layout>

<@layout.page>
    <div class="container py-5">
        <div class="card shadow-sm mx-auto" style="max-width: 720px;">
            <div class="card-header bg-primary text-white">
                <h1 class="h4 mb-0">
                    <#if courseDto.id??>
                        Редактирование курса
                    <#else>
                        Добавление курса
                    </#if>
                </h1>
            </div>
            <div class="card-body">
                <form action="/admin/courses/save" method="post">
                    <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
                    <input type="hidden" name="id" value="${courseDto.id!''}"/>
                    <div class="mb-3">
                        <label for="title" class="form-label">Название курса</label>
                        <input type="text" class="form-control" id="title" name="title" value="${courseDto.title!''}" required>
                        <#if courseDto?? && courseDto.hasErrors() && courseDto.getError('title')??>
                            <div class="invalid-feedback d-block">${courseDto.getError('title')}</div>
                        </#if>
                    </div>
                    <div class="mb-3">
                        <label for="code" class="form-label">Код курса</label>
                        <input type="text" class="form-control" id="code" name="code" value="${courseDto.code!''}" required>
                        <#if courseDto?? && courseDto.hasErrors() && courseDto.getError('code')??>
                            <div class="invalid-feedback d-block">${courseDto.getError('code')}</div>
                        </#if>
                    </div>
                    <div class="mb-3">
                        <label for="categoryId" class="form-label">Категория</label>
                        <select class="form-select" id="categoryId" name="categoryId" required>
                            <option value="" selected>Выберите категорию</option>
                            <#list categories as category>
                                <option value="${category.id?c}" <#if courseDto.categoryId?? && courseDto.categoryId == category.id>selected</#if>>${category.name}</option>
                            </#list>
                        </select>
                        <#if courseDto?? && courseDto.hasErrors() && courseDto.getError('categoryId')??>
                            <div class="invalid-feedback d-block">${courseDto.getError('categoryId')}</div>
                        </#if>
                    </div>
                    <div class="mb-3">
                        <label for="description" class="form-label">Описание</label>
                        <textarea class="form-control" id="description" name="description" rows="5">${courseDto.description!''}</textarea>
                        <#if courseDto?? && courseDto.hasErrors() && courseDto.getError('description')??>
                            <div class="invalid-feedback d-block">${courseDto.getError('description')}</div>
                        </#if>
                    </div>
                    <div class="mb-3">
                        <label for="duration" class="form-label">Продолжительность (часы)</label>
                        <input type="number" class="form-control" id="duration" name="duration" value="${courseDto.duration!''}" required>
                        <#if courseDto?? && courseDto.hasErrors() && courseDto.getError('duration')??>
                            <div class="invalid-feedback d-block">${courseDto.getError('duration')}</div>
                        </#if>
                    </div>
                    <div class="mb-3 form-check">
                        <input type="checkbox" class="form-check-input" id="individual" name="individual" ${courseDto.individual?string('checked', '')}>
                        <label class="form-check-label" for="individual">Индивидуальный курс</label>
                    </div>
                    <div class="mb-3 form-check">
                        <input type="checkbox" class="form-check-input" id="active" name="active" ${courseDto.active?string('checked', '')}>
                        <label class="form-check-label" for="active">Активен</label>
                    </div>
                    <div class="text-end">
                        <a href="/admin/courses" class="btn btn-outline-secondary me-2">Отмена</a>
                        <button type="submit" class="btn btn-primary">Сохранить</button>
                    </div>
                </form>
            </div>
        </div>
    </div>
</@layout.page>