const API = "http://localhost:8000/notificaciones";
let skip = 0;
const limit = 20;

function timeAgo(iso) {
  const d = new Date(iso);
  const now = new Date();
  const diff = Math.floor((now - d) / 1000);
  if (diff < 60) return diff + "s";
  if (diff < 3600) return Math.floor(diff/60) + "m";
  if (diff < 86400) return Math.floor(diff/3600) + "h";
  return Math.floor(diff/86400) + "d";
}

async function fetchGrouped() {
  const res = await fetch(`${API}/agrupadas?skip=${skip}&limit=${limit}`);
  const data = await res.json();
  return data;
}

function createItem(n) {
  const item = document.createElement('div');
  item.className = 'item' + (n.leido ? ' leido' : '');
  item.dataset.id = n.id;

  const icon = document.createElement('div');
  icon.className = 'icon';
  icon.textContent = n.tipo ? n.tipo[0].toUpperCase() : 'N';

  const body = document.createElement('div');
  body.className = 'body';

  const title = document.createElement('p');
  title.className = 'title';
  if (!n.leido) {
    const dot = document.createElement('span');
    dot.className = 'unread-dot';
    title.prepend(dot);
  }
  title.appendChild(document.createTextNode(n.titulo));

  const msg = document.createElement('p');
  msg.className = 'message';
  msg.textContent = n.mensaje;

  const meta = document.createElement('div');
  meta.className = 'meta';
  meta.innerHTML = `<span>${timeAgo(n.fecha_creacion)}</span><a href="#" data-id="${n.id}" class="full">Ver notificación completa</a>`;

  body.appendChild(title);
  body.appendChild(msg);
  body.appendChild(meta);

  item.appendChild(icon);
  item.appendChild(body);

 
  item.addEventListener('click', async (e) => {
    
    if (e.target && e.target.classList && e.target.classList.contains('full')) return;
    const id = item.dataset.id;
    await fetch(`${API}/${id}/leer`, { method: 'PATCH' });
    item.classList.add('leido');
    const dot = item.querySelector('.unread-dot');
    if (dot) dot.remove();
  });

  
  meta.querySelector('.full').addEventListener('click', (e) => {
    e.preventDefault();
    alert('Detalle:\n' + n.titulo + '\n\n' + n.mensaje);
  });

  return item;
}

function renderGrouped(data) {
  const content = document.getElementById('content');
  
  const dates = Object.keys(data).sort((a,b)=> b.localeCompare(a));
  dates.forEach(date => {
    const groupDiv = document.createElement('div');
    groupDiv.className = 'group';
    const title = document.createElement('div');
    title.className = 'group-title';
    title.textContent = new Date(date).toLocaleDateString();
    groupDiv.appendChild(title);

    data[date].forEach(n => {
      groupDiv.appendChild(createItem(n));
    });

    content.appendChild(groupDiv);
  });
}

async function loadMore() {
  const data = await fetchGrouped();
  renderGrouped(data);

  skip += limit;
}


document.getElementById('markAll').addEventListener('click', async () => {
  const items = document.querySelectorAll('.item:not(.leido)');
  for (const it of items) {
    const id = it.dataset.id;
    await fetch(`${API}/${id}/leer`, { method: 'PATCH' });
    it.classList.add('leido');
    const dot = it.querySelector('.unread-dot');
    if (dot) dot.remove();
  }
});


document.getElementById('verTodo').addEventListener('click', (e) => {
  e.preventDefault();
  
  document.getElementById('content').innerHTML = '';
  skip = 0;
  loadMore();
});


loadMore();
