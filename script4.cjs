const fs = require('fs');

const pt4 = `
function RidesScreen({ rides, sortBy, setSortBy, filters, setFilters, showFilters, setShowFilters, onBook, pickup, dropoff, category, setCategory }) {
  const cats = [{ id:"all", label:"All", icon:"search" }, { id:"bike", label:"Bike", icon:"bike" }, { id:"car", label:"Car", icon:"car" }, { id:"public", label:"Public", icon:"bus" }, { id:"women", label:"Women", icon:"women" }];

  return (
    <div style={{animation:"fadeIn .3s ease"}}>
      <div style={{padding:"18px 20px 12px",background:"#EAF2F8",position:"sticky",top:0,zIndex:10,borderBottom:"1px solid #C0D8E8"}}>
        <div style={{fontFamily:"Syne,sans-serif",fontSize:20,fontWeight:800,marginBottom:12}}>Available Rides</div>
        {pickup && dropoff && (
          <div style={{display:"flex",alignItems:"center",gap:6,fontSize:13,color:"#4A6B80",marginBottom:12}}>
            <Icon name="mapPin" size={12} color="#2872A1" /> {pickup}
            <Icon name="arrowRight" size={12} color="#4A6B80" />
            <Icon name="mapPin" size={12} color="#ff4d6d" /> {dropoff}
          </div>
        )}
        <div style={{display:"flex",gap:7,overflowX:"auto",paddingBottom:2}}>
          {cats.map(c => (
            <button key={c.id} onClick={() => setCategory(c.id)} className="chip" style={{
              background:category===c.id ? (c.id==="women"?"rgba(255,110,180,.15)":"rgba(40,114,161,.12)") : "#CBDDE9",
              border:\`1px solid \${category===c.id ? (c.id==="women"?"#ff6eb4":"#2872A1") : "#9BBCD0"}\`,
              color:category===c.id ? (c.id==="women"?"#ff6eb4":"#2872A1") : "#4A6B80",
              borderRadius:99, padding:"5px 12px", fontSize:12, fontWeight:600,
              display:"flex", alignItems:"center", gap:5, flexShrink:0, transition:"all .2s"
            }}>
              <Icon name={c.icon} size={11} color={category===c.id ? (c.id==="women"?"#ff6eb4":"#2872A1") : "#4A6B80"} />
              {c.label}
            </button>
          ))}
        </div>
        <div style={{display:"flex",gap:8,marginTop:10}}>
          <div style={{display:"flex",gap:6,flex:1,overflowX:"auto"}}>
            {[["low","💸 Low→High"],["high","💰 High→Low"],["fast","⚡ Fastest"]].map(([s,l]) => (
              <button key={s} onClick={() => setSortBy(s)} style={{
                background:sortBy===s?"rgba(40,114,161,.12)":"#CBDDE9",
                border:\`1px solid \${sortBy===s?"#2872A1":"#9BBCD0"}\`,
                color:sortBy===s?"#2872A1":"#4A6B80",
                borderRadius:8, padding:"5px 12px", fontSize:11, fontWeight:600, whiteSpace:"nowrap", flexShrink:0, transition:"all .2s"
              }}>{l}</button>
            ))}
          </div>
          <button onClick={() => setShowFilters(!showFilters)} style={{background:showFilters?"rgba(29,111,164,.15)":"#CBDDE9",border:\`1px solid \${showFilters?"#1D6FA4":"#9BBCD0"}\`,color:showFilters?"#1D6FA4":"#4A6B80",borderRadius:8,padding:"5px 10px",flexShrink:0,display:"flex",alignItems:"center",gap:4,fontSize:11,fontWeight:600}}>
            <Icon name="filter" size={12} color={showFilters?"#1D6FA4":"#4A6B80"} /> Filter
          </button>
        </div>
      </div>

      {showFilters && (
        <div style={{margin:"0 20px",padding:"14px",background:"#FFFFFF",border:"1px solid #9BBCD0",borderRadius:14,display:"grid",gridTemplateColumns:"1fr 1fr",gap:10,animation:"slideUp .2s ease"}}>
          {[
            { key:"vehicle", label:"Vehicle", opts:[["","All"],["bike","Bike"],["car","Car"],["suv","SUV"],["auto","Auto"],["bus","Bus"]] },
            { key:"brand", label:"Brand", opts:[["","Any"],["honda","Honda"],["toyota","Toyota"],["suzuki","Suzuki"],["hyundai","Hyundai"],["tata","Tata"]] },
            { key:"gender", label:"Driver", opts:[["","Any"],["women","Women ♀"],["men","Men"]] },
            { key:"ac", label:"AC", opts:[["","Any"],["yes","AC ❄️"],["no","Non-AC"]] },
          ].map(f => (
            <div key={f.key}>
              <div style={{fontSize:10,color:"#5A7A8F",fontWeight:700,textTransform:"uppercase",letterSpacing:.8,marginBottom:4}}>{f.label}</div>
              <select value={filters[f.key]} onChange={e => setFilters({...filters,[f.key]:e.target.value})}
                style={{background:"#CBDDE9",border:"1px solid #9BBCD0",borderRadius:8,padding:"8px 10px",fontSize:12,color:"#0D2137",width:"100%"}}>
                {f.opts.map(([v,l]) => <option key={v} value={v}>{l}</option>)}
              </select>
            </div>
          ))}
        </div>
      )}

      <div style={{padding:"12px 20px",display:"flex",flexDirection:"column",gap:12}}>
        {rides.length === 0 ? (
          <div style={{textAlign:"center",padding:"60px 0",color:"#4A6B80"}}>
            <div style={{fontSize:48,marginBottom:12}}>🔍</div>
            <div style={{fontFamily:"Syne,sans-serif",fontSize:18,fontWeight:700,color:"#0D2137",marginBottom:6}}>No rides found</div>
            <div style={{fontSize:13}}>Try adjusting your filters</div>
          </div>
        ) : rides.map((r,i) => (
          <RideCard key={r.id} ride={r} onBook={() => onBook(r)} delay={i * 0.05} />
        ))}
      </div>
    </div>
  );
}

function RideCard({ ride: r, onBook, delay = 0 }) {
  return (
    <div className="ride-card" onClick={onBook} style={{
      background:"#FFFFFF",
      border:\`1px solid \${r.womenOnly?"rgba(255,110,180,.25)":"#9BBCD0"}\`,
      borderRadius:18,padding:"16px",cursor:"pointer",
      transition:"all .25s", animation:\`slideUp .4s ease \${delay}s both\`,
      position:"relative", overflow:"hidden"
    }}>
      <div style={{position:"absolute",top:0,left:0,right:0,height:3,background:r.womenOnly?"linear-gradient(90deg,#ff6eb4,#d63a8a)":"linear-gradient(90deg,#2872A1,#1D6FA4)",borderRadius:"18px 18px 0 0"}}/>
      <div style={{display:"flex",alignItems:"center",justifyContent:"space-between",marginBottom:10}}>
        <div style={{display:"flex",alignItems:"center",gap:12}}>
          <div style={{width:46,height:46,borderRadius:14,background:r.womenOnly?"rgba(255,110,180,.1)":"rgba(40,114,161,.08)",border:\`1px solid \${r.womenOnly?"rgba(255,110,180,.3)":"rgba(40,114,161,.2)"}\`,display:"flex",alignItems:"center",justifyContent:"center"}}>
            <Icon name={r.icon} size={22} color={r.womenOnly?"#ff6eb4":"#2872A1"} />
          </div>
          <div>
            <div style={{fontFamily:"Syne,sans-serif",fontSize:16,fontWeight:700}}>{r.name}</div>
            <div style={{fontSize:12,color:"#4A6B80",marginTop:2,display:"flex",alignItems:"center",gap:8}}>
              <span>🏷 {r.brand}</span>
              <span>💺 {r.seats}</span>
              {r.ac && <span>❄️ AC</span>}
            </div>
          </div>
        </div>
        <div style={{textAlign:"right"}}>
          <div style={{fontFamily:"Syne,sans-serif",fontSize:26,fontWeight:800,color:r.womenOnly?"#ff6eb4":"#2872A1",lineHeight:1}}>₹{r.fare}</div>
          <div style={{fontSize:12,color:"#4A6B80",marginTop:2}}>⏱ {r.eta} min</div>
        </div>
      </div>
      <div style={{display:"flex",gap:6,flexWrap:"wrap",marginBottom:12}}>
        {r.womenOnly && <Badge label="♀ Women Only" color="#ff6eb4" bg="rgba(255,110,180,.1)" />}
        {r.shared && <Badge label="🤝 Shared" color="#1D6FA4" bg="rgba(29,111,164,.1)" />}
        {r.driver.gender === "women" && <Badge label="♀ Woman Driver" color="#ff6eb4" bg="rgba(255,110,180,.1)" />}
      </div>
      <div style={{display:"flex",alignItems:"center",gap:10,paddingTop:10,borderTop:"1px solid #CBDDE9"}}>
        <div style={{width:34,height:34,borderRadius:99,background:r.driver.color+"33",border:\`2px solid \${r.driver.color}55\`,display:"flex",alignItems:"center",justifyContent:"center",fontFamily:"Syne,sans-serif",fontSize:12,fontWeight:700,color:r.driver.color,flexShrink:0}}>
          {r.driver.avatar}
        </div>
        <div style={{flex:1}}>
          <div style={{fontSize:13,fontWeight:500}}>{r.driver.name}</div>
          <div style={{fontSize:12,color:"#4A6B80",display:"flex",alignItems:"center",gap:4}}>
            <Icon name="star" size={11} color="#f59e0b" style={{fill:"#f59e0b"}} />
            {r.driver.rating} · {r.driver.trips.toLocaleString()} trips
          </div>
        </div>
        <button onClick={e => {e.stopPropagation();}} style={{background:r.womenOnly?"linear-gradient(135deg,#ff6eb4,#d63a8a)":"linear-gradient(135deg,#2872A1,#1A5C8A)",color:"#fff",border:"none",borderRadius:9,padding:"8px 14px",fontSize:12,fontWeight:800,transition:"all .2s"}}>
          Book
        </button>
      </div>
    </div>
  );
}

function ShareScreen({ womenShare, setWomenShare, maxShare, setMaxShare, onSearch }) {
  return (
    <div style={{padding:"20px",animation:"fadeIn .3s ease"}}>
      <div style={{fontFamily:"Syne,sans-serif",fontSize:22,fontWeight:800,marginBottom:4}}>Share a Ride</div>
      <div style={{fontSize:14,color:"#4A6B80",marginBottom:20}}>Split fare with co-riders on the same route</div>

      <div style={{display:"flex",gap:0,marginBottom:20,background:"#FFFFFF",border:"1px solid #9BBCD0",borderRadius:16,overflow:"hidden"}}>
        {[["1","Find","Match with nearby riders"],["2","Confirm","Agree on route & fare"],["3","Ride","Save up to 40% fare"]].map(([n,t,d],i) => (
          <div key={n} style={{flex:1,padding:"14px 10px",textAlign:"center",borderRight:i<2?"1px solid #9BBCD0":"none"}}>
            <div style={{width:28,height:28,borderRadius:99,background:"linear-gradient(135deg,#2872A1,#1D6FA4)",display:"flex",alignItems:"center",justifyContent:"center",margin:"0 auto 6px",fontFamily:"Syne,sans-serif",fontSize:13,fontWeight:800,color:"#fff"}}>{n}</div>
            <div style={{fontFamily:"Syne,sans-serif",fontSize:12,fontWeight:700,marginBottom:2}}>{t}</div>
            <div style={{fontSize:11,color:"#4A6B80"}}>{d}</div>
          </div>
        ))}
      </div>

      <div style={{background:"#FFFFFF",border:"1px solid #9BBCD0",borderRadius:18,padding:16,marginBottom:14}}>
        <LocationInput icon="mapPin" iconColor="#2872A1" placeholder="Pickup location" />
        <div style={{width:2,height:12,background:"linear-gradient(#2872A1,#ff4d6d)",margin:"3px 0 3px 18px",borderRadius:99}}/>
        <LocationInput icon="mapPin" iconColor="#ff4d6d" placeholder="Destination" />
        <div style={{marginTop:14,display:"flex",flexDirection:"column",gap:10}}>
          <Toggle label="Women-only shared ride ♀" checked={womenShare} onChange={setWomenShare} accent="#ff6eb4" />
          <Toggle label="Max 2 co-riders only" checked={maxShare} onChange={setMaxShare} />
        </div>
      </div>

      <div style={{background:"rgba(40,114,161,.05)",border:"1px solid rgba(40,114,161,.15)",borderRadius:14,padding:"12px 14px",marginBottom:14,display:"flex",gap:10,alignItems:"flex-start"}}>
        <Icon name="shield" size={16} color="#2872A1" />
        <div>
          <div style={{fontSize:13,fontWeight:600,color:"#2872A1",marginBottom:2}}>Safe Sharing</div>
          <div style={{fontSize:12,color:"#4A6B80"}}>All co-riders are verified. Women-only mode pairs female passengers with female drivers only.</div>
        </div>
      </div>

      <button onClick={onSearch} style={{width:"100%",background:"linear-gradient(135deg,#1D6FA4,#155F8E)",color:"#fff",border:"none",borderRadius:12,padding:"14px",fontFamily:"Syne,sans-serif",fontSize:15,fontWeight:800,display:"flex",alignItems:"center",justifyContent:"center",gap:8}}>
        <Icon name="search" size={16} color="#fff" /> Find Shared Rides
      </button>

      <div style={{marginTop:20}}>
        <div style={{fontFamily:"Syne,sans-serif",fontSize:15,fontWeight:700,marginBottom:10}}>Available Shared Rides</div>
        {[
          { id:4, name:"ShareGo", type:"car", brand:"Hyundai", seats:4, fare:89, eta:8, ac:true, shared:true, womenOnly:false, icon:"car", driver:{name:"Amit R.",rating:4.7,gender:"men",trips:1560,avatar:"AR",color:"#06b6d4"}},
          { id:8, name:"CityBus", type:"bus", brand:"Tata", seats:30, fare:25, eta:12, ac:false, shared:true, womenOnly:false, icon:"bus", driver:{name:"Mohan D.",rating:4.3,gender:"men",trips:5400,avatar:"MD",color:"#155F8E"}},
          { id:10, name:"ShareHer", type:"car", brand:"Suzuki", seats:4, fare:99, eta:6, ac:true, shared:true, womenOnly:true, icon:"car", driver:{name:"Deepa K.",rating:4.9,gender:"women",trips:1340,avatar:"DK",color:"#ec4899"}},
        ].map((r,i) => (
          <div key={r.id} style={{background:"#FFFFFF",border:"1px solid #9BBCD0",borderRadius:14,padding:"12px 14px",marginBottom:10,display:"flex",alignItems:"center",gap:12}}>
            <div style={{width:40,height:40,borderRadius:10,background:"rgba(29,111,164,.1)",display:"flex",alignItems:"center",justifyContent:"center",flexShrink:0}}>
              <Icon name={r.icon} size={20} color="#1D6FA4" />
            </div>
            <div style={{flex:1}}>
              <div style={{fontFamily:"Syne,sans-serif",fontSize:14,fontWeight:700}}>{r.name}</div>
              <div style={{fontSize:12,color:"#4A6B80"}}>⏱ {r.eta} min · {r.driver.name} · ⭐{r.driver.rating}</div>
            </div>
            <div style={{textAlign:"right"}}>
              <div style={{fontFamily:"Syne,sans-serif",fontSize:18,fontWeight:800,color:"#1D6FA4"}}>₹{r.fare}</div>
              <div style={{fontSize:11,color:"#4A6B80"}}>per seat</div>
            </div>
          </div>
        ))}
      </div>
    </div>
  );
}

function SafetyScreen({ onSOS }) {
  return (
    <div style={{padding:"20px",animation:"fadeIn .3s ease"}}>
      <div style={{fontFamily:"Syne,sans-serif",fontSize:22,fontWeight:800,marginBottom:4}}>Safety Center</div>
      <div style={{fontSize:14,color:"#4A6B80",marginBottom:20}}>Your safety is our top priority</div>

      <div style={{textAlign:"center",padding:"28px 0",background:"#FFFFFF",border:"1px solid rgba(255,77,109,.2)",borderRadius:20,marginBottom:16,position:"relative",overflow:"hidden"}}>
        <div style={{fontSize:13,color:"#4A6B80",marginBottom:16}}>Emergency? Tap SOS immediately</div>
        <div style={{position:"relative",display:"inline-block"}} onClick={onSOS}>
          <div style={{position:"absolute",inset:-20,borderRadius:99,background:"rgba(255,77,109,.1)",animation:"ripple 1.5s ease-in-out infinite"}}/>
          <div style={{position:"absolute",inset:-10,borderRadius:99,background:"rgba(255,77,109,.15)",animation:"ripple 1.5s ease-in-out infinite .3s"}}/>
          <button style={{width:100,height:100,borderRadius:99,background:"linear-gradient(135deg,#ff4d6d,#ff0040)",border:"none",color:"#fff",fontFamily:"Syne,sans-serif",fontSize:18,fontWeight:900,letterSpacing:2,position:"relative",boxShadow:"0 8px 32px rgba(255,77,109,.5)",cursor:"pointer"}}>
            SOS
          </button>
        </div>
        <div style={{fontSize:12,color:"#5A7A8F",marginTop:20}}>Sends alert to emergency contacts & police</div>
      </div>

      {[
        {icon:"shield",color:"#2872A1",title:"Verified Drivers",desc:"All drivers are background-checked and ID-verified before onboarding."},
        {icon:"phone",color:"#1D6FA4",title:"Share Trip",desc:"Share your live location and trip details with trusted contacts."},
        {icon:"women",color:"#ff6eb4",title:"Women Safety Mode",desc:"Female passengers matched with female drivers. Route monitored live."},
        {icon:"location",color:"#f59e0b",title:"Live Tracking",desc:"Real-time GPS tracking shared with emergency contacts automatically."},
        {icon:"bell",color:"#06b6d4",title:"Ride Alerts",desc:"Get alerts if your route deviates or ride takes unusually long."},
      ].map(f => (
        <div key={f.title} style={{display:"flex",gap:14,background:"#FFFFFF",border:"1px solid #9BBCD0",borderRadius:14,padding:"14px",marginBottom:10}}>
          <div style={{width:42,height:42,borderRadius:12,background:f.color+"15",display:"flex",alignItems:"center",justifyContent:"center",flexShrink:0}}>
            <Icon name={f.icon} size={20} color={f.color} />
          </div>
          <div>
            <div style={{fontFamily:"Syne,sans-serif",fontSize:14,fontWeight:700,marginBottom:3}}>{f.title}</div>
            <div style={{fontSize:13,color:"#4A6B80",lineHeight:1.5}}>{f.desc}</div>
          </div>
        </div>
      ))}

      <div style={{background:"#FFFFFF",border:"1px solid #9BBCD0",borderRadius:14,padding:14,marginTop:4}}>
        <div style={{fontFamily:"Syne,sans-serif",fontSize:14,fontWeight:700,marginBottom:10,display:"flex",justifyContent:"space-between",alignItems:"center"}}>
          Emergency Contacts
          <button style={{background:"rgba(40,114,161,.1)",border:"1px solid rgba(40,114,161,.2)",color:"#2872A1",borderRadius:8,padding:"4px 10px",fontSize:12,fontWeight:600,display:"flex",alignItems:"center",gap:4}}>
            <Icon name="plus" size={11} color="#2872A1" /> Add
          </button>
        </div>
        {[{name:"Mom",phone:"+91 98765 43210"},{name:"Rahul (Friend)",phone:"+91 87654 32109"}].map(c => (
          <div key={c.name} style={{display:"flex",justifyContent:"space-between",alignItems:"center",padding:"8px 0",borderBottom:"1px solid #C0D8E8"}}>
            <div>
              <div style={{fontSize:13,fontWeight:500}}>{c.name}</div>
              <div style={{fontSize:12,color:"#4A6B80"}}>{c.phone}</div>
            </div>
            <Icon name="phone" size={14} color="#2872A1" />
          </div>
        ))}
      </div>
    </div>
  );
}

function ProfileScreen({ history }) {
  return (
    <div style={{padding:"20px",animation:"fadeIn .3s ease"}}>
      <div style={{background:"linear-gradient(135deg,rgba(29,111,164,.15),rgba(40,114,161,.1))",border:"1px solid #9BBCD0",borderRadius:20,padding:"20px",marginBottom:16,textAlign:"center"}}>
        <div style={{width:72,height:72,borderRadius:99,background:"linear-gradient(135deg,#1D6FA4,#2872A1)",display:"flex",alignItems:"center",justifyContent:"center",margin:"0 auto 12px",fontFamily:"Syne,sans-serif",fontSize:24,fontWeight:800,color:"#fff"}}>AJ</div>
        <div style={{fontFamily:"Syne,sans-serif",fontSize:20,fontWeight:800}}>Arjun Joshi</div>
        <div style={{fontSize:13,color:"#4A6B80",marginTop:2}}>+91 98765 43210</div>
        <div style={{display:"flex",gap:20,justifyContent:"center",marginTop:14}}>
          {[["42","Rides"],["4.9","Rating"],["₹2.4k","Saved"]].map(([v,l]) => (
            <div key={l} style={{textAlign:"center"}}>
              <div style={{fontFamily:"Syne,sans-serif",fontSize:20,fontWeight:800,color:"#2872A1"}}>{v}</div>
              <div style={{fontSize:11,color:"#4A6B80"}}>{l}</div>
            </div>
          ))}
        </div>
      </div>

      <div style={{background:"linear-gradient(135deg,#C0D8E8,#CBDDE9)",border:"1px solid rgba(29,111,164,.3)",borderRadius:16,padding:"16px",marginBottom:14,display:"flex",justifyContent:"space-between",alignItems:"center"}}>
        <div>
          <div style={{fontSize:12,color:"#4A6B80",marginBottom:3}}>ZIPP Wallet</div>
          <div style={{fontFamily:"Syne,sans-serif",fontSize:26,fontWeight:800,color:"#1D6FA4"}}>₹ 840.00</div>
        </div>
        <div style={{display:"flex",gap:8}}>
          <button style={{background:"rgba(29,111,164,.15)",border:"1px solid rgba(29,111,164,.3)",color:"#1D6FA4",borderRadius:10,padding:"8px 14px",fontSize:12,fontWeight:700}}>Add Money</button>
        </div>
      </div>

      <div style={{fontFamily:"Syne,sans-serif",fontSize:15,fontWeight:700,marginBottom:10,display:"flex",alignItems:"center",gap:6}}>
        <Icon name="history" size={15} color="#1D6FA4" /> Recent Rides
      </div>
      {history.map(h => (
        <div key={h.id} style={{background:"#FFFFFF",border:"1px solid #9BBCD0",borderRadius:14,padding:"12px 14px",marginBottom:10,display:"flex",gap:12,alignItems:"center"}}>
          <div style={{width:38,height:38,borderRadius:10,background:"rgba(40,114,161,.08)",border:"1px solid rgba(40,114,161,.15)",display:"flex",alignItems:"center",justifyContent:"center",flexShrink:0}}>
            <Icon name={h.type} size={18} color="#2872A1" />
          </div>
          <div style={{flex:1}}>
            <div style={{fontSize:13,fontWeight:500,marginBottom:2}}>{h.from} → {h.to}</div>
            <div style={{fontSize:12,color:"#4A6B80"}}>{h.date}</div>
          </div>
          <div>
            <div style={{fontFamily:"Syne,sans-serif",fontSize:16,fontWeight:700,color:"#2872A1",textAlign:"right"}}>₹{h.fare}</div>
            <div style={{fontSize:11,color:"#4A6B80",textAlign:"right"}}>{h.status}</div>
          </div>
        </div>
      ))}

      <div style={{background:"#FFFFFF",border:"1px solid #9BBCD0",borderRadius:16,overflow:"hidden",marginTop:6}}>
        {[
          {icon:"edit",label:"Edit Profile"},
          {icon:"wallet",label:"Payment Methods"},
          {icon:"bell",label:"Notifications"},
          {icon:"shield",label:"Privacy & Safety"},
          {icon:"settings",label:"Settings"},
          {icon:"logout",label:"Sign Out",color:"#ff4d6d"},
        ].map((item,i) => (
          <div key={item.label} style={{display:"flex",alignItems:"center",gap:12,padding:"13px 16px",borderBottom:i<5?"1px solid #C0D8E8":"none",cursor:"pointer"}}>
            <Icon name={item.icon} size={17} color={item.color||"#4A6B80"} />
            <span style={{flex:1,fontSize:14,fontWeight:500,color:item.color||"#0D2137"}}>{item.label}</span>
            <Icon name="chevDown" size={14} color="#6A90A0" style={{transform:"rotate(-90deg)"}} />
          </div>
        ))}
      </div>
    </div>
  );
}

function BottomNav({ tab, setTab }) {
  const items = [
    { id:"home", icon:"home", label:"Home" },
    { id:"rides", icon:"car", label:"Rides" },
    { id:"share", icon:"share", label:"Share" },
    { id:"safety", icon:"safety", label:"Safety" },
    { id:"profile", icon:"user", label:"Profile" },
  ];
  return (
    <div style={{position:"fixed",bottom:0,left:"50%",transform:"translateX(-50%)",width:"100%",maxWidth:430,background:"rgba(234,242,248,.95)",backdropFilter:"blur(20px)",borderTop:"1px solid #C0D8E8",display:"flex",zIndex:50,paddingBottom:"env(safe-area-inset-bottom,0px)"}}>
      {items.map(item => (
        <button key={item.id} onClick={() => setTab(item.id)} style={{flex:1,background:"transparent",border:"none",padding:"10px 0 8px",display:"flex",flexDirection:"column",alignItems:"center",gap:3,transition:"all .2s"}}>
          <div style={{width:36,height:36,borderRadius:10,background:tab===item.id?"rgba(40,114,161,.12)":"transparent",display:"flex",alignItems:"center",justifyContent:"center",transition:"all .2s"}}>
            <Icon name={item.icon} size={19} color={tab===item.id?"#2872A1":"#6A90A0"} />
          </div>
          <span style={{fontSize:10,fontWeight:600,color:tab===item.id?"#2872A1":"#6A90A0",fontFamily:"Syne,sans-serif",transition:"all .2s"}}>{item.label}</span>
        </button>
      ))}
    </div>
  );
}

function ConfirmModal({ ride: r, pickup, dropoff, onClose, onConfirm }) {
  return (
    <div style={{position:"fixed",inset:0,background:"rgba(13,33,55,.8)",backdropFilter:"blur(12px)",zIndex:200,display:"flex",alignItems:"flex-end"}}>
      <div style={{width:"100%",maxWidth:430,margin:"0 auto",background:"#FFFFFF",borderRadius:"24px 24px 0 0",padding:"24px",animation:"modalIn .3s ease",maxHeight:"90vh",overflowY:"auto"}}>
        <div style={{width:40,height:4,borderRadius:99,background:"#9BBCD0",margin:"0 auto 20px"}}/>
        <div style={{fontFamily:"Syne,sans-serif",fontSize:20,fontWeight:800,marginBottom:16,color:"#0D2137"}}>Confirm Ride</div>
        <div style={{background:"#CBDDE9",borderRadius:14,overflow:"hidden",marginBottom:16}}>
          {[
            ["Ride", \`\${r.name}\`],
            ["From", pickup||"Current Location"],
            ["To", dropoff||"Destination"],
            ["Driver", r.driver.name],
            ["ETA", \`\${r.eta} min\`],
            ["Fare", \`₹\${r.fare}\`, true],
            ...(r.womenOnly?[["Type","♀ Women Only"]]:r.shared?[["Type","🤝 Shared Ride"]]:[]),
          ].map(([k,v,accent],i,arr) => (
            <div key={k} style={{display:"flex",justifyContent:"space-between",alignItems:"center",padding:"11px 14px",borderBottom:i<arr.length-1?"1px solid #9BBCD0":"none"}}>
              <span style={{fontSize:13,color:"#4A6B80"}}>{k}</span>
              <span style={{fontSize:13,fontWeight:600,color:accent?"#2872A1":"#0D2137"}}>{v}</span>
            </div>
          ))}
        </div>
        <div style={{display:"flex",gap:10}}>
          <button onClick={onClose} style={{flex:1,background:"#CBDDE9",border:"1px solid #9BBCD0",color:"#0D2137",borderRadius:12,padding:"13px",fontSize:14,fontWeight:700}}>Cancel</button>
          <button onClick={onConfirm} style={{flex:2,background:"linear-gradient(135deg,#2872A1,#1A5C8A)",color:"#fff",border:"none",borderRadius:12,padding:"13px",fontSize:14,fontWeight:800,display:"flex",alignItems:"center",justifyContent:"center",gap:8}}>
            Confirm Booking <Icon name="arrowRight" size={16} color="#fff" />
          </button>
        </div>
      </div>
    </div>
  );
}

function SuccessModal({ ride: r, etaCount, onClose, onSOS }) {
  return (
    <div style={{position:"fixed",inset:0,background:"rgba(13,33,55,.85)",backdropFilter:"blur(14px)",zIndex:200,display:"flex",alignItems:"flex-end"}}>
      <div style={{width:"100%",maxWidth:430,margin:"0 auto",background:"#FFFFFF",borderRadius:"24px 24px 0 0",padding:"28px",animation:"modalIn .3s ease"}}>
        <div style={{textAlign:"center",marginBottom:20}}>
          <div style={{fontSize:56,animation:"float 2s ease-in-out infinite",display:"block"}}>✅</div>
          <div style={{fontFamily:"Syne,sans-serif",fontSize:22,fontWeight:800,marginTop:8}}>Ride Confirmed!</div>
          <div style={{fontSize:14,color:"#4A6B80",marginTop:4}}>Your driver is on the way</div>
        </div>
        <div style={{background:"#CBDDE9",borderRadius:16,padding:"14px",marginBottom:14,display:"flex",alignItems:"center",gap:12}}>
          <div style={{width:46,height:46,borderRadius:99,background:r.driver.color+"33",border:\`2px solid \${r.driver.color}55\`,display:"flex",alignItems:"center",justifyContent:"center",fontFamily:"Syne,sans-serif",fontSize:14,fontWeight:800,color:r.driver.color,flexShrink:0}}>
            {r.driver.avatar}
          </div>
          <div style={{flex:1}}>
            <div style={{fontFamily:"Syne,sans-serif",fontSize:15,fontWeight:700}}>{r.driver.name}</div>
            <div style={{fontSize:12,color:"#4A6B80"}}>⭐ {r.driver.rating} · {r.name} · {r.brand}</div>
          </div>
          <div style={{textAlign:"right"}}>
            <div style={{fontFamily:"Syne,sans-serif",fontSize:34,fontWeight:900,color:"#2872A1",lineHeight:1}}>{etaCount}</div>
            <div style={{fontSize:11,color:"#4A6B80"}}>min</div>
          </div>
        </div>
        <div style={{display:"flex",gap:10,marginBottom:12}}>
          <button style={{flex:1,background:"rgba(40,114,161,.1)",border:"1px solid rgba(40,114,161,.25)",color:"#2872A1",borderRadius:12,padding:"11px",fontSize:13,fontWeight:700,display:"flex",alignItems:"center",justifyContent:"center",gap:6}}>
            <Icon name="phone" size={14} color="#2872A1" /> Call Driver
          </button>
          <button style={{flex:1,background:"rgba(29,111,164,.1)",border:"1px solid rgba(29,111,164,.25)",color:"#1D6FA4",borderRadius:12,padding:"11px",fontSize:13,fontWeight:700,display:"flex",alignItems:"center",justifyContent:"center",gap:6}}>
            <Icon name="share" size={14} color="#1D6FA4" /> Share Trip
          </button>
        </div>
        <button onClick={onSOS} style={{width:"100%",background:"rgba(255,77,109,.1)",border:"1px solid rgba(255,77,109,.3)",color:"#ff4d6d",borderRadius:12,padding:"11px",fontSize:13,fontWeight:700,display:"flex",alignItems:"center",justifyContent:"center",gap:6,marginBottom:12}}>
          <Icon name="sos" size={14} color="#ff4d6d" /> SOS Emergency
        </button>
        <button onClick={onClose} style={{width:"100%",background:"linear-gradient(135deg,#2872A1,#1A5C8A)",color:"#fff",border:"none",borderRadius:12,padding:"13px",fontFamily:"Syne,sans-serif",fontSize:14,fontWeight:800}}>
          Track Live →
        </button>
      </div>
    </div>
  );
}

function SOSModal({ onClose }) {
  const [sent, setSent] = useState(false);
  const selectedContacts = [{name:"Mom", phone:"+91 98765 43210"}, {name:"Rahul (Friend)", phone:"+91 87654 32109"}];
  return (
    <div style={{position:"fixed",inset:0,background:"rgba(13,33,55,.9)",backdropFilter:"blur(16px)",zIndex:300,display:"flex",alignItems:"center",justifyContent:"center",padding:20}}>
      <div style={{background:"#FFFFFF",border:"2px solid rgba(255,77,109,.4)",borderRadius:24,padding:"28px",width:"100%",maxWidth:360,textAlign:"center",animation:"modalIn .2s ease"}}>
        {!sent ? (
          <>
            <div style={{fontSize:48,marginBottom:12,animation:"float 1s ease-in-out infinite"}}>🚨</div>
            <div style={{fontFamily:"Syne,sans-serif",fontSize:22,fontWeight:800,color:"#ff4d6d",marginBottom:6}}>Emergency SOS</div>
            <div style={{fontSize:14,color:"#4A6B80",marginBottom:10}}>
              This will automatically share your <strong style={{color:"#f59e0b"}}>Live Car Location</strong> and ride details to:
            </div>
            <div style={{background:"#EAF2F8",borderRadius:12,padding:10,marginBottom:20}}>
               {selectedContacts.map(c => (
                 <div key={c.name} style={{fontSize:13,color:"#0D2137",padding:"4px 0"}}>✅ {c.name} ({c.phone})</div>
               ))}
               <div style={{fontSize:13,color:"#1D6FA4",padding:"4px 0",fontWeight:"bold"}}>📞 Local Police Control Room</div>
            </div>
            <button onClick={() => setSent(true)} style={{width:"100%",background:"linear-gradient(135deg,#ff4d6d,#ff0040)",color:"#fff",border:"none",borderRadius:14,padding:"16px",fontFamily:"Syne,sans-serif",fontSize:16,fontWeight:900,letterSpacing:2,marginBottom:10,boxShadow:"0 8px 32px rgba(255,77,109,.5)"}}>
              SEND SOS & LOCATION NOW
            </button>
            <button onClick={onClose} style={{width:"100%",background:"transparent",border:"1px solid #9BBCD0",color:"#5A7A8F",borderRadius:12,padding:"12px",fontSize:14,fontWeight:600}}>Cancel</button>
          </>
        ) : (
          <>
            <div style={{fontSize:48,marginBottom:12}}>✅</div>
            <div style={{fontFamily:"Syne,sans-serif",fontSize:20,fontWeight:800,color:"#2872A1",marginBottom:6}}>Location Shared!</div>
            <div style={{fontSize:14,color:"#4A6B80",marginBottom:6}}>Emergency contacts and authorities have received your live location link.</div>
            <div style={{fontSize:13,color:"#4A6B80",marginBottom:20}}>Help is on the way. The driver's details have been forwarded.</div>
            <button onClick={onClose} style={{width:"100%",background:"linear-gradient(135deg,#2872A1,#1A5C8A)",color:"#fff",border:"none",borderRadius:12,padding:"13px",fontFamily:"Syne,sans-serif",fontSize:14,fontWeight:800}}>Close</button>
          </>
        )}
      </div>
    </div>
  );
}

function LocationInput({ icon, iconColor, value, onChange, placeholder }) {
  return (
    <div style={{display:"flex",alignItems:"center",gap:10,background:"#CBDDE9",border:"1px solid #9BBCD0",borderRadius:10,padding:"11px 13px",transition:"border-color .2s"}}>
      <Icon name={icon} size={15} color={iconColor} />
      <input value={value||""} onChange={e => onChange && onChange(e.target.value)} placeholder={placeholder} style={{color:"#0D2137",fontSize:14}} />
    </div>
  );
}

function Toggle({ label, checked, onChange, accent = "#2872A1" }) {
  return (
    <label style={{display:"flex",alignItems:"center",gap:10,cursor:"pointer",fontSize:13,color:"#0D2137"}}>
      <div onClick={() => onChange(!checked)} style={{width:42,height:24,borderRadius:99,background:checked?\`\${accent}22\`:"#CBDDE9",border:\`1px solid \${checked?accent:"#9BBCD0"}\`,position:"relative",transition:"all .25s",flexShrink:0}}>
        <div style={{position:"absolute",top:3,left:checked?19:3,width:16,height:16,borderRadius:99,background:checked?accent:"#6A90A0",transition:"all .25s"}}/>
      </div>
      {label}
    </label>
  );
}

function Badge({ label, color, bg }) {
  return (
    <span style={{background:bg,border:\`1px solid \${color}55\`,color:color,borderRadius:99,padding:"3px 10px",fontSize:11,fontWeight:600,display:"inline-flex",alignItems:"center"}}>
      {label}
    </span>
  );
}

function PulseDot({ color = "#2872A1" }) {
  return (
    <span style={{display:"inline-block",width:7,height:7,borderRadius:99,background:color,animation:"pulse 1.5s ease-in-out infinite"}}/>
  );
}

function IconBtn({ icon, onClick }) {
  return (
    <button onClick={onClick} style={{width:38,height:38,borderRadius:10,background:"#FFFFFF",border:"1px solid #9BBCD0",display:"flex",alignItems:"center",justifyContent:"center",transition:"all .2s"}}>
      <Icon name={icon} size={16} color="#4A6B80" />
    </button>
  );
}
`;

fs.writeFileSync('rebuild_4.jsx', pt4, 'utf8');

const finalCode = fs.readFileSync('rebuild_1.jsx', 'utf8') + 
                  fs.readFileSync('rebuild_2.jsx', 'utf8') + 
                  fs.readFileSync('rebuild_3.jsx', 'utf8') + 
                  fs.readFileSync('rebuild_4.jsx', 'utf8');

fs.writeFileSync('ZippApp.jsx', finalCode, 'utf8');
console.log('Merged successfully! Saved to ZippApp.jsx');
