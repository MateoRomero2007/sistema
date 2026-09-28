(() => {
    "use strict";

    const puestos = document.querySelectorAll(".puesto");
    const modal = document.getElementById("modal");
    const cerrar = document.getElementById("cerrar");
    const tituloPuesto = document.getElementById("tituloPuesto");
    const estadoPuesto = document.getElementById("estadoPuesto");
    const modalNombre = document.getElementById("modalNombre");
    const modalArea = document.getElementById("modalArea");
    const modalDiaCasa = document.getElementById("modalDiaCasa");
    const modalHorario = document.getElementById("modalHorario");
    const modalObservacion = document.getElementById("modalObservacion");
    const modalFoto = document.getElementById("modalFoto");
    const contenedorFoto = document.getElementById("contenedorFoto");
    const reservarBtn = document.getElementById("reservarBtn");
    const cancelarReservaBtn = document.getElementById("cancelarReservaBtn");
    const modalReserva = document.getElementById("modalReserva");
    const cerrarReserva = document.getElementById("cerrarReserva");
    const cancelarFormulario = document.getElementById("cancelarFormulario");
    const confirmarReserva = document.getElementById("confirmarReserva");
    const nombreReserva = document.getElementById("nombreReserva");
    const areaReserva = document.getElementById("areaReserva");
    const claveReserva = document.getElementById("claveReserva");
    const puestoReservaTexto = document.getElementById("puestoReservaTexto");
    const modalCancelar = document.getElementById("modalCancelar");
    const cerrarCancelar = document.getElementById("cerrarCancelar");
    const mantenerReserva = document.getElementById("mantenerReserva");
    const confirmarCancelacion = document.getElementById("confirmarCancelacion");
    const nombreCancelacion = document.getElementById("nombreCancelacion");
    const areaCancelacion = document.getElementById("areaCancelacion");
    const claveCancelacion = document.getElementById("claveCancelacion");
    const filtroArea = document.getElementById("filtroArea");
    const fechaHoy = document.querySelector("[data-fecha-hoy]");
    const sinPuestoLista = document.getElementById("sinPuestoLista");
    const sinPuestoToggle = document.getElementById("sinPuestoToggle");
    const mapaEscala = document.querySelector(".mapa-escala");
    const mapa = document.querySelector(".mapa");
    const syncEstado = document.getElementById("syncEstado");
    const syncTexto = document.getElementById("syncTexto");
    const tooltip = document.createElement("div");
    tooltip.className = "tooltip-puesto";
    tooltip.setAttribute("role", "status");
    document.body.appendChild(tooltip);
    const liderGeneral = document.querySelector(".lider-general");
    liderGeneral?.style.setProperty("border", "2px solid #b8e7ff", "important");
    liderGeneral?.style.setProperty("box-shadow", "0 0 8px #159acb, 0 0 20px rgba(21, 154, 203, .78)", "important");

    let puestoSeleccionado = null;
    let datosPuestos = {};
    let fechaReserva = "";

    const dias = ["domingo", "lunes", "martes", "miercoles", "jueves", "viernes", "sabado"];

    function normalizar(texto) {
        return (texto || "").normalize("NFD").replace(/[\u0300-\u036f]/g, "").trim().toLowerCase();
    }

    function escaparHtml(texto) {
        return String(texto ?? "").replace(/[&<>"']/g, caracter => ({
            "&": "&amp;",
            "<": "&lt;",
            ">": "&gt;",
            '"': "&quot;",
            "'": "&#039;"
        })[caracter]);
    }

    function fechaManana() {
        const f = new Date();
        f.setDate(f.getDate() + 1);
        while (f.getDay() === 0 || f.getDay() === 6) {
            f.setDate(f.getDate() + 1);
        }
        return f.toISOString().slice(0, 10);
    }

    function formatearFecha(fecha) {
        const f = new Date(`${fecha}T00:00:00`);
        return f.toLocaleDateString("es-CO", { weekday: "long", day: "2-digit", month: "long", year: "numeric" });
    }

    function diaDeFecha(fecha) {
        return dias[new Date(`${fecha}T00:00:00`).getDay()];
    }

    function ajustarEscalaMapa() {
        if (!mapaEscala || !mapa) return;
        const escala = window.innerWidth <= 700 ? 0.72 : Math.min(1, mapaEscala.clientWidth / 1450);
        mapaEscala.style.setProperty("--escala-mapa", escala);
    }

    function cargarAreas() {
        if (!filtroArea) return;
        const existentes = new Set([...filtroArea.options].map(o => o.value));
        const areas = [...puestos].map(p => p.dataset.area).filter(Boolean);
        [...new Set(areas.map(a => [normalizar(a), a]))]
            .sort((a, b) => a[1].localeCompare(b[1], "es"))
            .forEach(([clave, area]) => {
                if (clave === "todas las areas" || existentes.has(clave)) return;
                const option = document.createElement("option");
                option.value = clave;
                option.textContent = area;
                filtroArea.appendChild(option);
                existentes.add(clave);
            });
    }

    function aplicarFiltro() {
        const seleccion = filtroArea?.value || "todas";
        puestos.forEach(p => {
            const area = normalizar(p.dataset.area);
            p.classList.toggle("filtro-oculto", seleccion !== "todas" && area !== seleccion);
        });
    }

    function puedeReservarse(puesto) {
        const data = datosPuestos[puesto.dataset.codigo];
        if (!data || !data.reservable || !data.estado || data.reservado) return false;
        const diaCasa = normalizar(data.dia_casa);
        const dia = diaDeFecha(fechaReserva);
        return diaCasa === dia;
    }

    function actualizarEstados() {
        puestos.forEach(puesto => {
            const codigo = puesto.dataset.codigo;
            const data = datosPuestos[codigo];
            if (!data || !codigo) return;
            const atributos = {
                codigo: data.codigo_puesto,
                puesto: data.numero_puesto,
                nombre: data.nombre,
                area: data.area,
                diaCasa: data.dia_casa,
                horario: data.horario,
                observacion: data.observacion || data.motivo,
                ubicacion: data.ubicacion
            };
            Object.entries(atributos).forEach(([atributo, valor]) => {
                const nombreAtributo = atributo.replace(/[A-Z]/g, letra => `-${letra.toLowerCase()}`);
                if (valor) puesto.setAttribute(`data-${nombreAtributo}`, valor);
            });
            const esLider = normalizar(data.cargo).includes("lider");
            puesto.classList.toggle("lider", esLider);
            puesto.style.setProperty("border", esLider ? "2px solid #b8e7ff" : "", "important");
            puesto.style.setProperty("box-shadow", esLider ? "0 0 8px #159acb, 0 0 20px rgba(21, 154, 203, .78)" : "", "important");
            puesto.classList.toggle("no-reservable", !data.reservable || !data.estado);
            puesto.classList.toggle("reservado", !!data.reservado);
            puesto.classList.toggle("libre", !!data.reservable && !!data.estado && !data.reservado);
            puesto.classList.toggle("disponible-fecha", !!data.disponible);
            puesto.dataset.reservado = data.reservado ? "true" : "false";
        });
    }

    function actualizarTooltip(puesto, evento) {
        const data = datosPuestos[puesto.dataset.codigo] || {};
        const nombre = data.nombre || puesto.dataset.nombre || "Sin asignar";
        const area = data.area || puesto.dataset.area || "Sin área";
        const diaCasa = data.dia_casa || puesto.dataset.diaCasa || "Sin definir";
        const horario = data.horario || puesto.dataset.horario || "Sin definir";
        const ubicacion = data.ubicacion || puesto.dataset.ubicacion || "Sin definir";
        const observacion = data.observacion || data.motivo || puesto.dataset.observacion || puesto.dataset.motivo || "Sin observaciones";
        const estado = data.reservado ? "RESERVADO" : data.disponible ? "DISPONIBLE PARA RESERVA" : data.reservable && data.estado ? `NO DISPONIBLE PARA RESERVA EL ${diaDeFecha(fechaReserva).toUpperCase()}` : "NO RESERVABLE";
        const claseEstado = data.reservado ? "tooltip-reservado" : data.disponible ? "tooltip-disponible" : "tooltip-no-disponible";
        tooltip.innerHTML = `<div class="tooltip-titulo">${escaparHtml(data.codigo_puesto || puesto.dataset.codigo)} - ${escaparHtml(data.numero_puesto || puesto.dataset.puesto || "Puesto")}</div><div class="tooltip-dato"><span>PERSONA</span><strong>${escaparHtml(nombre)}</strong></div><div class="tooltip-dato"><span>ÁREA</span><strong>${escaparHtml(area)}</strong></div><div class="tooltip-dato"><span>DÍA DESDE CASA</span><strong>${escaparHtml(diaCasa)}</strong></div><div class="tooltip-dato"><span>HORARIO</span><strong>${escaparHtml(horario)}</strong></div><div class="tooltip-dato"><span>UBICACIÓN</span><strong>${escaparHtml(ubicacion)}</strong></div><div class="tooltip-dato"><span>OBSERVACIÓN</span><strong>${escaparHtml(observacion)}</strong></div><div class="tooltip-dato"><span>ESTADO</span><strong class="${claseEstado}">${escaparHtml(estado)}</strong></div>`;
        tooltip.classList.add("visible");
        tooltip.style.left = `${Math.min(evento.clientX + 16, window.innerWidth - 300)}px`;
        tooltip.style.top = `${Math.min(evento.clientY + 16, window.innerHeight - 220)}px`;
    }

    function ocultarTooltip() {
        tooltip.classList.remove("visible");
    }

    function abrirModal(puesto) {
        puestoSeleccionado = puesto;
        const data = datosPuestos[puesto.dataset.codigo] || {};
        tituloPuesto.textContent = data.codigo_puesto ? `${data.codigo_puesto} - ${data.numero_puesto || "Puesto"}` : (puesto.dataset.puesto || "Puesto");
        modalNombre.textContent = data.nombre || puesto.dataset.nombre || "-";
        modalArea.textContent = data.area || puesto.dataset.area || "-";
        modalDiaCasa.textContent = data.dia_casa || puesto.dataset.diaCasa || "-";
        modalHorario.textContent = data.horario || puesto.dataset.horario || "-";
        modalObservacion.textContent = data.observacion || data.motivo || puesto.dataset.observacion || puesto.dataset.motivo || "-";

        if (data.foto || puesto.querySelector("img")?.src) {
            modalFoto.src = data.foto || puesto.querySelector("img").src;
            modalFoto.alt = data.nombre || puesto.dataset.nombre || "Foto";
            contenedorFoto.style.display = "flex";
        } else {
            contenedorFoto.style.display = "none";
        }

        const noReservable = !data.codigo_puesto || !data.reservable || !data.estado || puesto.classList.contains("no-reservable");
        const reservado = !!data.reservado;
        const permitido = puedeReservarse(puesto);

        if (reservado) {
            estadoPuesto.textContent = `RESERVADO PARA ${formatearFecha(fechaReserva).toUpperCase()}`;
            estadoPuesto.className = "estado-reservado";
        } else if (noReservable) {
            estadoPuesto.textContent = "NO RESERVABLE";
            estadoPuesto.className = "estado-no-reservable";
        } else if (!permitido) {
            estadoPuesto.textContent = `NO DISPONIBLE PARA RESERVA EL ${diaDeFecha(fechaReserva).toUpperCase()}`;
            estadoPuesto.className = "estado-no-reservable";
        } else {
            estadoPuesto.textContent = "DISPONIBLE PARA RESERVA";
            estadoPuesto.className = "estado-disponible";
        }

        reservarBtn.style.display = !noReservable && !reservado && permitido ? "block" : "none";
        cancelarReservaBtn.style.display = reservado ? "block" : "none";
        modal.classList.add("activo");
    }

    function cerrarModal() {
        modal.classList.remove("activo");
        puestoSeleccionado = null;
    }

    function abrirReserva() {
        if (!puestoSeleccionado || !puedeReservarse(puestoSeleccionado)) return;
        puestoReservaTexto.textContent = `${puestoSeleccionado.dataset.codigo} - ${puestoSeleccionado.dataset.puesto || "Puesto"}`;
        nombreReserva.value = "";
        areaReserva.value = "";
        claveReserva.value = "";
        modal.classList.remove("activo");
        modalReserva.style.display = "flex";
        modalReserva.classList.add("visible");
        setTimeout(() => nombreReserva.focus(), 100);
    }

    function cerrarReservaModal() {
        modalReserva.classList.remove("visible");
        modalReserva.style.display = "none";
    }

    async function realizarReserva() {
        const nombre = nombreReserva.value.trim();
        const area = areaReserva.value.trim();
        const clave = claveReserva.value;
        const codigo = puestoSeleccionado?.dataset.codigo;
        if (!codigo) return;
        if (!nombre || !area || clave.length < 4) return alert("Escribe tu nombre, área y una clave de al menos 4 caracteres.");

        confirmarReserva.disabled = true;
        try {
            const respuesta = await fetch("reservar_puesto.php", {
                method: "POST",
                headers: { "Content-Type": "application/json" },
                body: JSON.stringify({ codigo_puesto: codigo, nombre, area, clave })
            });
            const data = await respuesta.json();
            if (!respuesta.ok || !data.ok) throw new Error(data.mensaje || "No se pudo realizar la reserva.");
            alert(`${data.mensaje}\nFecha: ${formatearFecha(data.fecha)}.`);
            cerrarReservaModal();
            await cargarDatos();
            abrirModal(document.querySelector(`.puesto[data-codigo="${codigo}"]`));
        } catch (error) {
            alert(error.message);
        } finally {
            confirmarReserva.disabled = false;
        }
    }

    function abrirCancelacion() {
        modal.classList.remove("activo");
        nombreCancelacion.value = "";
        areaCancelacion.value = "";
        claveCancelacion.value = "";
        modalCancelar.style.display = "flex";
        modalCancelar.classList.add("visible");
        setTimeout(() => nombreCancelacion.focus(), 100);
    }

    function cerrarCancelacion() {
        modalCancelar.classList.remove("visible");
        modalCancelar.style.display = "none";
    }

    async function cancelarReserva() {
        const codigo = puestoSeleccionado?.dataset.codigo;
        if (!codigo) return;
        const nombre = nombreCancelacion.value.trim();
        const area = areaCancelacion.value.trim();
        const clave = claveCancelacion.value;
        if (!nombre || !area || clave.length < 4) return alert("Escribe nombre, área y clave de reserva.");
        confirmarCancelacion.disabled = true;
        try {
            const respuesta = await fetch("cancelar_reserva.php", {
                method: "POST",
                headers: { "Content-Type": "application/json" },
                body: JSON.stringify({ codigo_puesto: codigo, nombre, area, clave })
            });
            const data = await respuesta.json();
            if (!respuesta.ok || !data.ok) throw new Error(data.mensaje || "No se pudo cancelar la reserva.");
            alert(data.mensaje);
            cerrarCancelacion();
            await cargarDatos();
            const puestoActualizado = document.querySelector(`.puesto[data-codigo="${codigo}"]`);
            if (puestoActualizado) abrirModal(puestoActualizado);
        } catch (error) {
            alert(error.message);
        } finally {
            confirmarCancelacion.disabled = false;
        }
    }

    function cargarSinPuesto(personas) {
        if (!sinPuestoLista) return;
        sinPuestoLista.innerHTML = "";
        sinPuestoLista.classList.remove("expandida");
        if (sinPuestoToggle) {
            sinPuestoToggle.hidden = !personas?.length || personas.length < 2;
            sinPuestoToggle.setAttribute("aria-expanded", "false");
            sinPuestoToggle.textContent = "+";
        }
        if (!personas?.length) {
            sinPuestoLista.innerHTML = '<div class="sin-puesto-vacio">No hay personas registradas.</div>';
            return;
        }
        personas.forEach(persona => {
            const item = document.createElement("div");
            const claseArea = normalizar(persona.area).replace(/\s+/g, "-");
            item.className = `sin-puesto-persona area-${claseArea || "sin-definir"}`;
            const avatar = document.createElement("div");
            avatar.className = "sin-puesto-avatar";
            const inicial = (persona.nombre || "?").charAt(0).toUpperCase();
            if (persona.foto) {
                const imagen = document.createElement("img");
                imagen.src = persona.foto;
                imagen.alt = persona.nombre || "Foto";
                imagen.onerror = () => {
                    avatar.textContent = inicial;
                };
                avatar.appendChild(imagen);
            } else {
                avatar.textContent = inicial;
            }
            const datos = document.createElement("div");
            const nombre = document.createElement("strong");
            nombre.textContent = persona.nombre || "Sin nombre";
            const area = document.createElement("span");
            area.textContent = persona.area || "Sin área";
            datos.append(nombre, area);
            item.append(avatar, datos);
            sinPuestoLista.appendChild(item);
        });
    }

    sinPuestoToggle?.addEventListener("click", () => {
        const expandida = sinPuestoLista.classList.toggle("expandida");
        sinPuestoToggle.setAttribute("aria-expanded", String(expandida));
        sinPuestoToggle.textContent = expandida ? "−" : "+";
        sinPuestoToggle.title = expandida ? "Ocultar personas" : "Mostrar más personas";
    });

    async function cargarDatos() {
        const respuesta = await fetch(`obtener_puestos.php?fecha=${encodeURIComponent(fechaReserva)}`, { cache: "no-store" });
        const data = await respuesta.json();
        if (!respuesta.ok || !data.ok) throw new Error(data.mensaje || "No se pudieron cargar los puestos.");
        datosPuestos = {};
        data.puestos.forEach(p => datosPuestos[p.codigo_puesto] = p);
        cargarSinPuesto(data.sin_puesto_fijo);
        actualizarEstados();
    }

    // --- Sincronización automática en segundo plano ---
    // Mantiene el mapa al día en todas las pestañas/pantallas abiertas sin
    // recargar la página (nada de autorefresh): sólo vuelve a pedir los
    // datos por AJAX y refresca el estado visual de los puestos.
    const INTERVALO_SYNC_MS = 8000;
    let sincronizando = false;
    let temporizadorSync = null;

    function marcarEstadoSync(estado) {
        if (!syncEstado || !syncTexto) return;
        syncEstado.classList.remove("sync-error", "sync-actualizando");
        if (estado === "actualizando") {
            syncEstado.classList.add("sync-actualizando");
            syncTexto.textContent = "Actualizando…";
        } else if (estado === "error") {
            syncEstado.classList.add("sync-error");
            syncTexto.textContent = "Sin conexión";
        } else {
            const hora = new Date().toLocaleTimeString("es-CO", { hour: "2-digit", minute: "2-digit" });
            syncTexto.textContent = `Sincronizado · ${hora}`;
        }
    }

    async function sincronizarSilencioso() {
        if (sincronizando) return;
        sincronizando = true;
        marcarEstadoSync("actualizando");
        try {
            await cargarDatos();
            marcarEstadoSync("ok");
        } catch (error) {
            console.error("Sincronización automática fallida:", error);
            marcarEstadoSync("error");
        } finally {
            sincronizando = false;
        }
    }

    function iniciarSincronizacion() {
        if (temporizadorSync) return;
        temporizadorSync = setInterval(sincronizarSilencioso, INTERVALO_SYNC_MS);
    }

    function detenerSincronizacion() {
        clearInterval(temporizadorSync);
        temporizadorSync = null;
    }

    document.addEventListener("visibilitychange", () => {
        if (document.hidden) {
            detenerSincronizacion();
        } else {
            sincronizarSilencioso();
            iniciarSincronizacion();
        }
    });

    function actualizarFecha() {
        if (fechaHoy) fechaHoy.textContent = `RESERVAS PARA: ${formatearFecha(fechaReserva).toUpperCase()}`;
    }

    puestos.forEach(puesto => {
        puesto.addEventListener("click", () => abrirModal(puesto));
        puesto.addEventListener("mouseenter", evento => actualizarTooltip(puesto, evento));
        puesto.addEventListener("mousemove", evento => actualizarTooltip(puesto, evento));
        puesto.addEventListener("mouseleave", ocultarTooltip);
    });

    cerrar?.addEventListener("click", cerrarModal);
    reservarBtn?.addEventListener("click", abrirReserva);
    cancelarReservaBtn?.addEventListener("click", abrirCancelacion);
    cerrarReserva?.addEventListener("click", cerrarReservaModal);
    cancelarFormulario?.addEventListener("click", cerrarReservaModal);
    confirmarReserva?.addEventListener("click", realizarReserva);
    cerrarCancelar?.addEventListener("click", cerrarCancelacion);
    mantenerReserva?.addEventListener("click", cerrarCancelacion);
    confirmarCancelacion?.addEventListener("click", cancelarReserva);
    filtroArea?.addEventListener("change", aplicarFiltro);

    [modal, modalReserva, modalCancelar].forEach(elemento => {
        elemento?.addEventListener("click", e => {
            if (e.target === elemento) {
                elemento.classList.remove("activo", "visible");
                elemento.style.display = "none";
            }
        });
    });

    fechaReserva = fechaManana();
    actualizarFecha();
    cargarAreas();
    aplicarFiltro();
    ajustarEscalaMapa();
    window.addEventListener("resize", ajustarEscalaMapa);

    cargarDatos()
        .then(() => {
            marcarEstadoSync("ok");
            if (!document.hidden) iniciarSincronizacion();
        })
        .catch(error => {
            console.error(error);
            marcarEstadoSync("error");
            alert("No se pudo conectar con PHP/MySQL. Revisa XAMPP y conexion.php.");
        });
})();
