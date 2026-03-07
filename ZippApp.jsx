import { useState, useEffect, useRef } from "react";

// ─── SVG ICON SYSTEM ──────────────────────────────────────────────────────────
const Icon = ({ name, size = 20, color = "currentColor", className = "" }) => {
  const icons = {
    home: <><path d="M3 9.5L12 3l9 6.5V20a1 1 0 01-1 1H5a1 1 0 01-1-1V9.5z"/><path d="M9 21V12h6v9"/></>,
    search: <><circle cx="11" cy="11" r="8"/><path d="m21 21-4.35-4.35"/></>,
    share: <><circle cx="18" cy="5" r="3"/><circle cx="6" cy="12" r="3"/><circle cx="18" cy="19" r="3"/><line x1="8.59" y1="13.51" x2="15.42" y2="17.49"/><line x1="15.41" y1="6.51" x2="8.59" y2="10.49"/></>,
    user: <><path d="M20 21v-2a4 4 0 00-4-4H8a4 4 0 00-4 4v2"/><circle cx="12" cy="7" r="4"/></>,
    safety: <><path d="M12 22s8-4 8-10V5l-8-3-8 3v7c0 6 8 10 8 10z"/></>,
    bell: <><path d="M18 8A6 6 0 006 8c0 7-3 9-3 9h18s-3-2-3-9"/><path d="M13.73 21a2 2 0 01-3.46 0"/></>,
    mapPin: <><path d="M21 10c0 7-9 13-9 13s-9-6-9-13a9 9 0 0118 0z"/><circle cx="12" cy="10" r="3"/></>,
    car: <><path d="M5 17H3a2 2 0 01-2-2V5a2 2 0 012-2h11l5 5v9a2 2 0 01-2 2h-2"/><circle cx="7.5" cy="17.5" r="2.5"/><circle cx="17.5" cy="17.5" r="2.5"/></>,
    bike: <><circle cx="18.5" cy="17.5" r="3.5"/><circle cx="5.5" cy="17.5" r="3.5"/><path d="M15 6h-3l-3 11.5M6 17.5l4-7h7.5"/><path d="M15 6l2.5 5H12"/></>,
    bus: <><rect x="2" y="3" width="20" height="16" rx="2"/><path d="M2 9h20M2 14h20M7 3v16M17 3v16"/><circle cx="5" cy="19" r="1"/><circle cx="19" cy="19" r="1"/></>,
    auto: <><path d="M2 17l1-7h15l1 7H2z"/><path d="M3 10V7a2 2 0 012-2h10a2 2 0 012 2v3"/><circle cx="7" cy="17" r="2"/><circle cx="15" cy="17" r="2"/></>,
    arrowRight: <><line x1="5" y1="12" x2="19" y2="12"/><polyline points="12 5 19 12 12 19"/></>,
    arrowLeft: <><line x1="19" y1="12" x2="5" y2="12"/><polyline points="12 19 5 12 12 5"/></>,
    check: <><polyline points="20 6 9 17 4 12"/></>,
    x: <><line x1="18" y1="6" x2="6" y2="18"/><line x1="6" y1="6" x2="18" y2="18"/></>,
    star: <><polygon points="12 2 15.09 8.26 22 9.27 17 14.14 18.18 21.02 12 17.77 5.82 21.02 7 14.14 2 9.27 8.91 8.26 12 2"/></>,
    filter: <><line x1="4" y1="6" x2="20" y2="6"/><line x1="8" y1="12" x2="16" y2="12"/><line x1="12" y1="18" x2="12" y2="18"/></>,
    shield: <><path d="M12 22s8-4 8-10V5l-8-3-8 3v7c0 6 8 10 8 10z"/><polyline points="9 12 11 14 15 10"/></>,
    phone: <><path d="M22 16.92v3a2 2 0 01-2.18 2 19.79 19.79 0 01-8.63-3.07A19.5 19.5 0 013.07 9.81 19.79 19.79 0 01.17 1.18 2 2 0 012.18 0h3a2 2 0 012 1.72c.127.96.361 1.903.7 2.81a2 2 0 01-.45 2.11L6.91 7.91a16 16 0 006.72 6.72l1.07-1.07a2 2 0 012.11-.45c.907.339 1.85.573 2.81.7A2 2 0 0122 16.92z"/></>,
    clock: <><circle cx="12" cy="12" r="10"/><polyline points="12 6 12 12 16 14"/></>,
    women: <><circle cx="12" cy="8" r="4"/><path d="M12 12v8M9 17h6"/></>,
    users: <><path d="M17 21v-2a4 4 0 00-4-4H5a4 4 0 00-4 4v2"/><circle cx="9" cy="7" r="4"/><path d="M23 21v-2a4 4 0 00-3-3.87"/><path d="M16 3.13a4 4 0 010 7.75"/></>,
    zap: <><polygon points="13 2 3 14 12 14 11 22 21 10 12 10 13 2"/></>,
    sort: <><path d="M3 6h18M7 12h10M11 18h2"/></>,
    chevDown: <><polyline points="6 9 12 15 18 9"/></>,
    chevUp: <><polyline points="18 15 12 9 6 15"/></>,
    plus: <><line x1="12" y1="5" x2="12" y2="19"/><line x1="5" y1="12" x2="19" y2="12"/></>,
    sos: <><path d="M10.29 3.86L1.82 18a2 2 0 001.71 3h16.94a2 2 0 001.71-3L13.71 3.86a2 2 0 00-3.42 0z"/><line x1="12" y1="9" x2="12" y2="13"/><line x1="12" y1="17" x2="12.01" y2="17"/></>,
    location: <><circle cx="12" cy="12" r="3"/><path d="M12 2a10 10 0 100 20A10 10 0 0012 2z" strokeDasharray="3 3"/></>,
    gift: <><polyline points="20 12 20 22 4 22 4 12"/><rect x="2" y="7" width="20" height="5"/><line x1="12" y1="22" x2="12" y2="7"/><path d="M12 7H7.5a2.5 2.5 0 010-5C11 2 12 7 12 7z"/><path d="M12 7h4.5a2.5 2.5 0 000-5C13 2 12 7 12 7z"/></>,
    wallet: <><rect x="2" y="5" width="20" height="14" rx="2"/><line x1="16" y1="12" x2="16.01" y2="12"/><path d="M22 9H16a2 2 0 000 4h6"/></>,
    history: <><polyline points="1 4 1 10 7 10"/><path d="M3.51 15a9 9 0 102.13-9.36L1 10"/></>,
    settings: <><circle cx="12" cy="12" r="3"/><path d="M19.4 15a1.65 1.65 0 00.33 1.82l.06.06a2 2 0 010 2.83 2 2 0 01-2.83 0l-.06-.06a1.65 1.65 0 00-1.82-.33 1.65 1.65 0 00-1 1.51V21a2 2 0 01-4 0v-.09A1.65 1.65 0 009 19.4a1.65 1.65 0 00-1.82.33l-.06.06a2 2 0 01-2.83-2.83l.06-.06A1.65 1.65 0 004.68 15a1.65 1.65 0 00-1.51-1H3a2 2 0 010-4h.09A1.65 1.65 0 004.6 9a1.65 1.65 0 00-.33-1.82l-.06-.06a2 2 0 012.83-2.83l.06.06A1.65 1.65 0 009 4.68a1.65 1.65 0 001-1.51V3a2 2 0 014 0v.09a1.65 1.65 0 001 1.51 1.65 1.65 0 001.82-.33l.06-.06a2 2 0 012.83 2.83l-.06.06A1.65 1.65 0 0019.4 9a1.65 1.65 0 001.51 1H21a2 2 0 010 4h-.09a1.65 1.65 0 00-1.51 1z"/></>,
    logout: <><path d="M9 21H5a2 2 0 01-2-2V5a2 2 0 012-2h4"/><polyline points="16 17 21 12 16 7"/><line x1="21" y1="12" x2="9" y2="12"/></>,
    edit: <><path d="M11 4H4a2 2 0 00-2 2v14a2 2 0 002 2h14a2 2 0 002-2v-7"/><path d="M18.5 2.5a2.121 2.121 0 013 3L12 15l-4 1 1-4 9.5-9.5z"/></>,
  };
  return (
    <svg width={size} height={size} viewBox="0 0 24 24" fill="none" stroke={color} strokeWidth="1.8" strokeLinecap="round" strokeLinejoin="round" className={className}>
      {icons[name] || null}
    </svg>
  );
};

// ─── DATA ─────────────────────────────────────────────────────────────────────
const RIDES = [
  { id:1, name:"QuickBike", type:"bike", brand:"Honda", seats:1, fare:49, eta:3, ac:false, shared:false, womenOnly:false, icon:"bike", driver:{name:"Ravi K.",rating:4.8,gender:"men",trips:1240,avatar:"RK",color:"#7b5ef8"}},
  { id:2, name:"AutoRide", type:"auto", brand:"Bajaj", seats:3, fare:79, eta:5, ac:false, shared:false, womenOnly:false, icon:"auto", driver:{name:"Suresh M.",rating:4.6,gender:"men",trips:980,avatar:"SM",color:"#f59e0b"}},
  { id:3, name:"MiniCab", type:"car", brand:"Suzuki", seats:4, fare:119, eta:6, ac:true, shared:false, womenOnly:false, icon:"car", driver:{name:"Priya S.",rating:4.9,gender:"women",trips:2100,avatar:"PS",color:"#ec4899"}},
  { id:4, name:"ShareGo", type:"car", brand:"Hyundai", seats:4, fare:89, eta:8, ac:true, shared:true, womenOnly:false, icon:"car", driver:{name:"Amit R.",rating:4.7,gender:"men",trips:1560,avatar:"AR",color:"#06b6d4"}},
  { id:5, name:"SafeHer Bike", type:"bike", brand:"Honda", seats:1, fare:59, eta:4, ac:false, shared:false, womenOnly:true, icon:"bike", driver:{name:"Neha G.",rating:5.0,gender:"women",trips:890,avatar:"NG",color:"#f43f5e"}},
  { id:6, name:"ComfortCar", type:"car", brand:"Toyota", seats:4, fare:179, eta:7, ac:true, shared:false, womenOnly:false, icon:"car", driver:{name:"Karan T.",rating:4.5,gender:"men",trips:3200,avatar:"KT",color:"#10b981"}},
  { id:7, name:"SafeHer Cab", type:"car", brand:"Tata", seats:4, fare:149, eta:9, ac:true, shared:false, womenOnly:true, icon:"car", driver:{name:"Anjali M.",rating:4.9,gender:"women",trips:1780,avatar:"AM",color:"#f43f5e"}},
  { id:8, name:"CityBus", type:"bus", brand:"Tata", seats:30, fare:25, eta:12, ac:false, shared:true, womenOnly:false, icon:"bus", driver:{name:"Mohan D.",rating:4.3,gender:"men",trips:5400,avatar:"MD",color:"#8b5cf6"}},
  { id:9, name:"PremiumSUV", type:"suv", brand:"Toyota", seats:6, fare:299, eta:10, ac:true, shared:false, womenOnly:false, icon:"car", driver:{name:"Vikram S.",rating:4.8,gender:"men",trips:2900,avatar:"VS",color:"#f59e0b"}},
  { id:10, name:"ShareHer", type:"car", brand:"Suzuki", seats:4, fare:99, eta:6, ac:true, shared:true, womenOnly:true, icon:"car", driver:{name:"Deepa K.",rating:4.9,gender:"women",trips:1340,avatar:"DK",color:"#ec4899"}},
];

const PROMO = [
  { code:"ZIPP20", desc:"20% off first 3 rides", color:"#7b5ef8" },
  { code:"SHARE50", desc:"50% off shared rides", color:"#00e5a0" },
  { code:"SAFEHER", desc:"Free ride for women drivers", color:"#f43f5e" },
];

const HISTORY = [
  { id:"BK001", date:"Today, 2:30 PM", from:"MG Road", to:"Koramangala", fare:149, status:"completed", type:"car" },
  { id:"BK002", date:"Yesterday, 9:15 AM", from:"Home", to:"Office", fare:59, status:"completed", type:"bike" },
  { id:"BK003", date:"Mon, 8:00 AM", from:"Airport", to:"Hotel", fare:299, status:"completed", type:"car" },
];

// ─── MAIN APP ─────────────────────────────────────────────────────────────────
export default function ZippApp() {
  const [screen, setScreen] = useState("splash");
  const [tab, setTab] = useState("home");
  const [bookingTab, setBookingTab] = useState("ride");
  const [category, setCategory] = useState("all");
  const [pickup, setPickup] = useState("");
  const [dropoff, setDropoff] = useState("");
  const [showResults, setShowResults] = useState(false);
  const [sortBy, setSortBy] = useState("low");
  const [filters, setFilters] = useState({ vehicle:"", brand:"", seats:"", gender:"", ac:"" });
  const [showFilters, setShowFilters] = useState(false);
  const [selectedRide, setSelectedRide] = useState(null);
  const [modal, setModal] = useState(null); // "confirm" | "success" | "sos"
  const [bookedRide, setBookedRide] = useState(null);
  const [womenShare, setWomenShare] = useState(false);
  const [maxShare, setMaxShare] = useState(false);
  const [activeRide, setActiveRide] = useState(null);
  const [etaCount, setEtaCount] = useState(0);
  const [splashDone, setSplashDone] = useState(false);
  const timerRef = useRef(null);

  // Splash
  useEffect(() => {
    const t = setTimeout(() => { setScreen("home"); setSplashDone(true); }, 2400);
    return () => clearTimeout(t);
  }, []);

  // ETA countdown
  useEffect(() => {
    if (activeRide) {
      setEtaCount(activeRide.eta);
      timerRef.current = setInterval(() => {
        setEtaCount(p => { if (p <= 1) { clearInterval(timerRef.current); return 0; } return p - 1; });
      }, 1000);
    }
    return () => clearInterval(timerRef.current);
  }, [activeRide]);

  const filteredRides = () => {
    let r = [...RIDES];
    if (category === "bike") r = r.filter(x => x.type === "bike");
    else if (category === "car") r = r.filter(x => x.type === "car" || x.type === "suv");
    else if (category === "public") r = r.filter(x => x.type === "bus" || x.type === "auto");
    else if (category === "women") r = r.filter(x => x.womenOnly);
    if (filters.vehicle) r = r.filter(x => x.type === filters.vehicle);
    if (filters.brand) r = r.filter(x => x.brand.toLowerCase() === filters.brand);
    if (filters.gender === "women") r = r.filter(x => x.driver.gender === "women");
    if (filters.gender === "men") r = r.filter(x => x.driver.gender === "men");
    if (filters.ac === "yes") r = r.filter(x => x.ac);
    if (filters.ac === "no") r = r.filter(x => !x.ac);
    if (sortBy === "low") r.sort((a,b) => a.fare - b.fare);
    else if (sortBy === "high") r.sort((a,b) => b.fare - a.fare);
    else if (sortBy === "fast") r.sort((a,b) => a.eta - b.eta);
    return r;
  };

  const handleBook = () => {
    setBookedRide(selectedRide);
    setActiveRide(selectedRide);
    setModal("success");
  };

  const closeModal = () => setModal(null);

  // ── SPLASH SCREEN ──────────────────────────────────────────────────────────
  if (screen === "splash") return (
    <div style={{
      position:"fixed", inset:0, background:"#080810",
      display:"flex", flexDirection:"column", alignItems:"center", justifyContent:"center",
      fontFamily:"'Syne', sans-serif", gap:24,
      animation:"fadeIn .3s ease"
    }}>
      <style>{`
        @import url('https://fonts.googleapis.com/css2?family=Syne:wght@400;600;700;800&family=DM+Sans:opsz,wght@9..40,300;9..40,400;9..40,500&display=swap');
        @keyframes splashBar { to { width: 100% } }
        @keyframes fadeIn { from{opacity:0} to{opacity:1} }
        @keyframes slideUp { from{transform:translateY(30px);opacity:0} to{transform:translateY(0);opacity:1} }
        @keyframes pulse { 0%,100%{opacity:1;transform:scale(1)} 50%{opacity:.4;transform:scale(1.6)} }
        @keyframes float { 0%,100%{transform:translateY(0)} 50%{transform:translateY(-8px)} }
        @keyframes spin { to{transform:rotate(360deg)} }
        @keyframes ripple { to{transform:scale(4);opacity:0} }
        @keyframes pinBounce { 0%,100%{transform:translateY(0)} 50%{transform:translateY(-6px)} }
      `}</style>
      <div style={{textAlign:"center",animation:"slideUp .6s ease"}}>
        <div style={{fontSize:80,fontWeight:800,letterSpacing:-4,lineHeight:1}}>
          <span style={{color:"#00e5a0"}}>Z</span>
          <span style={{color:"#f0f0f8"}}>IPP</span>
        </div>
        <div style={{fontSize:12,letterSpacing:5,color:"#666688",marginTop:8,textTransform:"uppercase"}}>
          Ride · Share · Arrive
        </div>
      </div>
      <div style={{width:180,height:3,background:"#1c1c28",borderRadius:99,overflow:"hidden",marginTop:8}}>
        <div style={{height:"100%",width:0,background:"linear-gradient(90deg,#00e5a0,#7b5ef8)",borderRadius:99,animation:"splashBar 2s ease forwards"}}/>
      </div>
    </div>
  );

  // ── MAIN APP SHELL ─────────────────────────────────────────────────────────
  return (
    <div style={{
      maxWidth:430, margin:"0 auto", minHeight:"100vh",
      background:"#080810", color:"#f0f0f8",
      fontFamily:"'DM Sans', sans-serif", position:"relative",
      overflow:"hidden", display:"flex", flexDirection:"column"
    }}>
      <style>{`
        @import url('https://fonts.googleapis.com/css2?family=Syne:wght@400;600;700;800&family=DM+Sans:opsz,wght@9..40,300;9..40,400;9..40,500&display=swap');
        @keyframes slideUp { from{transform:translateY(30px);opacity:0} to{transform:translateY(0);opacity:1} }
        @keyframes fadeIn { from{opacity:0} to{opacity:1} }
        @keyframes pulse { 0%,100%{opacity:1;transform:scale(1)} 50%{opacity:.3;transform:scale(2)} }
        @keyframes float { 0%,100%{transform:translateY(0)} 50%{transform:translateY(-8px)} }
        @keyframes pinBounce { 0%,100%{transform:translateY(0)} 50%{transform:translateY(-6px)} }
        @keyframes ripple { 0%{transform:scale(1);opacity:.5} 100%{transform:scale(3.5);opacity:0} }
        @keyframes spin { to{transform:rotate(360deg)} }
        @keyframes modalIn { from{transform:translateY(100%)} to{transform:translateY(0)} }
        @keyframes sosFlash { 0%,100%{background:#ff4d6d} 50%{background:#ff0040} }
        * { box-sizing: border-box; margin: 0; padding: 0; }
        input, select { background: transparent; border: none; outline: none; color: #f0f0f8; font-family: 'DM Sans', sans-serif; width: 100%; font-size: 14px; }
        select option { background: #1c1c28; color: #f0f0f8; }
        button { cursor: pointer; font-family: 'Syne', sans-serif; }
        ::-webkit-scrollbar { display: none; }
        .ride-card:hover { transform: translateY(-2px); }
        .chip:hover { opacity: .85; }
        .tab-btn.active-tab { color: #00e5a0 !important; }
      `}</style>

      {/* ── CONTENT AREA ── */}
      <div style={{flex:1, overflowY:"auto", paddingBottom:80}}>
        {tab === "home" && <HomeScreen
          bookingTab={bookingTab} setBookingTab={setBookingTab}
          category={category} setCategory={setCategory}
          pickup={pickup} setPickup={setPickup}
          dropoff={dropoff} setDropoff={setDropoff}
          womenShare={womenShare} setWomenShare={setWomenShare}
          maxShare={maxShare} setMaxShare={setMaxShare}
          onSearch={() => { setShowResults(true); setTab("rides"); }}
          activeRide={activeRide} etaCount={etaCount}
          onSOS={() => setModal("sos")}
        />}
        {tab === "rides" && <RidesScreen
          rides={filteredRides()} sortBy={sortBy} setSortBy={setSortBy}
          filters={filters} setFilters={setFilters}
          showFilters={showFilters} setShowFilters={setShowFilters}
          onBook={(r) => { setSelectedRide(r); setModal("confirm"); }}
          pickup={pickup} dropoff={dropoff}
          category={category} setCategory={setCategory}
        />}
        {tab === "share" && <ShareScreen
          womenShare={womenShare} setWomenShare={setWomenShare}
          maxShare={maxShare} setMaxShare={setMaxShare}
          onSearch={() => { setCategory("women"); setSortBy("low"); setTab("rides"); }}
        />}
        {tab === "safety" && <SafetyScreen onSOS={() => setModal("sos")} />}
        {tab === "profile" && <ProfileScreen history={HISTORY} />}
      </div>

      {/* ── BOTTOM NAV ── */}
      <BottomNav tab={tab} setTab={setTab} />

      {/* ── MODALS ── */}
      {modal === "confirm" && selectedRide && (
        <ConfirmModal ride={selectedRide} pickup={pickup} dropoff={dropoff}
          onClose={closeModal} onConfirm={handleBook} />
      )}
      {modal === "success" && bookedRide && (
        <SuccessModal ride={bookedRide} etaCount={etaCount}
          onClose={() => { closeModal(); setTab("home"); }} onSOS={() => setModal("sos")} />
      )}
      {modal === "sos" && <SOSModal onClose={closeModal} />}
    </div>
  );
}

// ─── HOME SCREEN ──────────────────────────────────────────────────────────────
function HomeScreen({ bookingTab, setBookingTab, category, setCategory, pickup, setPickup, dropoff, setDropoff, womenShare, setWomenShare, maxShare, setMaxShare, onSearch, activeRide, etaCount, onSOS }) {
  const cats = [
    { id:"all", label:"All", icon:"search" },
    { id:"bike", label:"Bike", icon:"bike" },
    { id:"car", label:"Car", icon:"car" },
    { id:"public", label:"Public", icon:"bus" },
    { id:"women", label:"Women Only", icon:"women" },
  ];

  return (
    <div style={{animation:"fadeIn .4s ease"}}>
      {/* Header */}
      <div style={{padding:"18px 20px 0", display:"flex", alignItems:"center", justifyContent:"space-between"}}>
        <div>
          <div style={{fontSize:13,color:"#00e5a0",fontWeight:500,display:"flex",alignItems:"center",gap:6}}>
            <PulseDot /> Pune, Maharashtra
          </div>
          <div style={{fontFamily:"Syne,sans-serif",fontSize:22,fontWeight:800,marginTop:2}}>
            Good morning, Arjun 👋
          </div>
        </div>
        <div style={{display:"flex",gap:10}}>
          <IconBtn icon="bell" />
          <div style={{width:40,height:40,borderRadius:99,background:"linear-gradient(135deg,#7b5ef8,#00e5a0)",display:"flex",alignItems:"center",justifyContent:"center",fontSize:14,fontWeight:700}}>
            AJ
          </div>
        </div>
      </div>

      {/* Active Ride Banner */}
      {activeRide && (
        <div style={{margin:"16px 20px 0",background:"linear-gradient(135deg,rgba(0,229,160,.15),rgba(123,94,248,.1))",border:"1px solid rgba(0,229,160,.3)",borderRadius:16,padding:"14px 16px",animation:"slideUp .4s ease"}}>
          <div style={{fontSize:12,color:"#00e5a0",fontWeight:600,textTransform:"uppercase",letterSpacing:1,marginBottom:8}}>🟢 Active Ride</div>
          <div style={{display:"flex",alignItems:"center",justifyContent:"space-between"}}>
            <div>
              <div style={{fontFamily:"Syne,sans-serif",fontSize:16,fontWeight:700}}>{activeRide.name}</div>
              <div style={{fontSize:13,color:"#8888aa",marginTop:2}}>Driver: {activeRide.driver.name}</div>
            </div>
            <div style={{textAlign:"right"}}>
              <div style={{fontFamily:"Syne,sans-serif",fontSize:28,fontWeight:800,color:"#00e5a0"}}>{etaCount}</div>
              <div style={{fontSize:11,color:"#8888aa"}}>min away</div>
            </div>
          </div>
          <button onClick={onSOS} style={{marginTop:10,width:"100%",background:"rgba(255,77,109,.15)",border:"1px solid rgba(255,77,109,.4)",color:"#ff4d6d",borderRadius:10,padding:"8px",fontSize:13,fontWeight:700,display:"flex",alignItems:"center",justifyContent:"center",gap:6}}>
            <Icon name="sos" size={14} color="#ff4d6d" /> SOS Emergency
          </button>
        </div>
      )}

      {/* Booking Card */}
      <div style={{margin:"16px 20px 0",background:"#12121a",border:"1px solid #2a2a3a",borderRadius:20,padding:18,boxShadow:"0 8px 32px rgba(0,0,0,.5)"}}>
        {/* Tabs */}
        <div style={{display:"flex",gap:4,background:"#1c1c28",borderRadius:12,padding:4,marginBottom:16}}>
          {[["ride","car","Ride"],["share","users","Share"],["schedule","clock","Schedule"]].map(([id,ico,lbl]) => (
            <button key={id} onClick={() => setBookingTab(id)} style={{flex:1,background:bookingTab===id?"#12121a":"transparent",border:"none",color:bookingTab===id?"#f0f0f8":"#666688",borderRadius:9,padding:"8px 0",fontSize:12,fontWeight:700,transition:"all .2s",boxShadow:bookingTab===id?"0 2px 8px rgba(0,0,0,.4)":"none",display:"flex",alignItems:"center",justifyContent:"center",gap:5}}>
              <Icon name={ico} size={13} color={bookingTab===id?"#00e5a0":"#666688"} /> {lbl}
            </button>
          ))}
        </div>

        {bookingTab === "ride" && (
          <>
            <LocationInput icon="mapPin" iconColor="#00e5a0" value={pickup} onChange={setPickup} placeholder="Pickup location" />
            <div style={{width:2,height:12,background:"linear-gradient(#00e5a0,#ff4d6d)",margin:"3px 0 3px 18px",borderRadius:99}}/>
            <LocationInput icon="mapPin" iconColor="#ff4d6d" value={dropoff} onChange={setDropoff} placeholder="Where to?" />
            <div style={{display:"flex",gap:7,marginTop:14,flexWrap:"wrap"}}>
              {cats.map(c => (
                <button key={c.id} className="chip" onClick={() => setCategory(c.id)} style={{
                  background:category===c.id ? (c.id==="women"?"rgba(255,110,180,.15)":"rgba(0,229,160,.12)") : "#1c1c28",
                  border:`1px solid ${category===c.id ? (c.id==="women"?"#ff6eb4":"#00e5a0") : "#2a2a3a"}`,
                  color:category===c.id ? (c.id==="women"?"#ff6eb4":"#00e5a0") : "#8888aa",
                  borderRadius:99, padding:"5px 12px", fontSize:12, fontWeight:600,
                  display:"flex", alignItems:"center", gap:5, transition:"all .2s"
                }}>
                  <Icon name={c.icon} size={11} color={category===c.id ? (c.id==="women"?"#ff6eb4":"#00e5a0") : "#8888aa"} />
                  {c.label}
                </button>
              ))}
            </div>
            <button onClick={onSearch} style={{marginTop:14,width:"100%",background:"linear-gradient(135deg,#00e5a0,#00b87a)",color:"#080810",border:"none",borderRadius:12,padding:"13px",fontFamily:"Syne,sans-serif",fontSize:14,fontWeight:800,letterSpacing:.5,display:"flex",alignItems:"center",justifyContent:"center",gap:8,transition:"all .2s"}}>
              Search Fares <Icon name="arrowRight" size={16} color="#080810" />
            </button>
          </>
        )}

        {bookingTab === "share" && (
          <>
            <LocationInput icon="mapPin" iconColor="#00e5a0" placeholder="Your pickup" />
            <div style={{width:2,height:12,background:"linear-gradient(#00e5a0,#ff4d6d)",margin:"3px 0 3px 18px",borderRadius:99}}/>
            <LocationInput icon="mapPin" iconColor="#ff4d6d" placeholder="Destination" />
            <div style={{marginTop:14,display:"flex",flexDirection:"column",gap:10}}>
              <Toggle label="Women-only shared ride" checked={womenShare} onChange={setWomenShare} />
              <Toggle label="Max 2 co-riders" checked={maxShare} onChange={setMaxShare} />
            </div>
            <div style={{marginTop:12,background:"rgba(123,94,248,.08)",border:"1px solid rgba(123,94,248,.2)",borderRadius:10,padding:"10px 14px",fontSize:13,color:"#8888aa",display:"flex",alignItems:"center",gap:8}}>
              <Icon name="zap" size={14} color="#7b5ef8" /> Sharing saves up to <span style={{color:"#f0f0f8",fontWeight:600}}>&nbsp;40%</span> on your fare
            </div>
            <button onClick={onSearch} style={{marginTop:12,width:"100%",background:"linear-gradient(135deg,#7b5ef8,#5b3fd8)",color:"#fff",border:"none",borderRadius:12,padding:"13px",fontFamily:"Syne,sans-serif",fontSize:14,fontWeight:800,letterSpacing:.5,display:"flex",alignItems:"center",justifyContent:"center",gap:8}}>
              Find Shared Rides <Icon name="arrowRight" size={16} color="#fff" />
            </button>
          </>
        )}

        {bookingTab === "schedule" && (
          <>
            <LocationInput icon="mapPin" iconColor="#00e5a0" placeholder="Pickup location" />
            <div style={{width:2,height:12,background:"linear-gradient(#00e5a0,#ff4d6d)",margin:"3px 0 3px 18px",borderRadius:99}}/>
            <LocationInput icon="mapPin" iconColor="#ff4d6d" placeholder="Destination" />
            <div style={{marginTop:10,display:"flex",alignItems:"center",gap:12,background:"#1c1c28",border:"1px solid #2a2a3a",borderRadius:10,padding:"12px 14px"}}>
              <Icon name="clock" size={16} color="#7b5ef8" />
              <input type="datetime-local" style={{color:"#8888aa",fontSize:13}} />
            </div>
            <button style={{marginTop:12,width:"100%",background:"linear-gradient(135deg,#f59e0b,#d97706)",color:"#080810",border:"none",borderRadius:12,padding:"13px",fontFamily:"Syne,sans-serif",fontSize:14,fontWeight:800,display:"flex",alignItems:"center",justifyContent:"center",gap:8}}>
              Schedule Ride <Icon name="clock" size={16} color="#080810" />
            </button>
          </>
        )}
      </div>

      {/* Promo Strip */}
      <div style={{padding:"20px 20px 0"}}>
        <div style={{fontFamily:"Syne,sans-serif",fontSize:15,fontWeight:700,marginBottom:10,display:"flex",alignItems:"center",gap:6}}>
          <Icon name="gift" size={15} color="#00e5a0" /> Offers for you
        </div>
        <div style={{display:"flex",gap:10,overflowX:"auto",paddingBottom:4}}>
          {PROMO.map(p => (
            <div key={p.code} style={{minWidth:160,background:"#12121a",border:`1px solid ${p.color}33`,borderRadius:14,padding:"12px 14px",flexShrink:0}}>
              <div style={{fontFamily:"Syne,sans-serif",fontSize:16,fontWeight:800,color:p.color}}>{p.code}</div>
              <div style={{fontSize:12,color:"#8888aa",marginTop:3}}>{p.desc}</div>
            </div>
          ))}
        </div>
      </div>

      {/* Quick Actions */}
      <div style={{padding:"20px 20px 0"}}>
        <div style={{fontFamily:"Syne,sans-serif",fontSize:15,fontWeight:700,marginBottom:12}}>Quick Actions</div>
        <div style={{display:"grid",gridTemplateColumns:"1fr 1fr",gap:10}}>
          {[
            {icon:"history",label:"Past Rides",color:"#7b5ef8",bg:"rgba(123,94,248,.1)"},
            {icon:"wallet",label:"Wallet",color:"#f59e0b",bg:"rgba(245,158,11,.1)"},
            {icon:"shield",label:"Safety",color:"#00e5a0",bg:"rgba(0,229,160,.1)"},
            {icon:"gift",label:"Offers",color:"#ec4899",bg:"rgba(236,72,153,.1)"},
          ].map(q => (
            <div key={q.label} style={{background:q.bg,border:`1px solid ${q.color}30`,borderRadius:14,padding:"14px",display:"flex",alignItems:"center",gap:10,cursor:"pointer"}}>
              <div style={{width:36,height:36,borderRadius:10,background:q.color+"22",display:"flex",alignItems:"center",justifyContent:"center"}}>
                <Icon name={q.icon} size={17} color={q.color} />
              </div>
              <div style={{fontFamily:"Syne,sans-serif",fontSize:14,fontWeight:700}}>{q.label}</div>
            </div>
          ))}
        </div>
      </div>

      {/* Map Preview */}
      <div style={{margin:"20px 20px 0",height:160,background:"#12121a",border:"1px solid #2a2a3a",borderRadius:20,overflow:"hidden",position:"relative"}}>
        <div style={{position:"absolute",inset:0,background:"radial-gradient(circle at 40% 50%,rgba(0,229,160,.05),transparent 70%),repeating-linear-gradient(0deg,transparent,transparent 28px,rgba(255,255,255,.025) 28px,rgba(255,255,255,.025) 29px),repeating-linear-gradient(90deg,transparent,transparent 28px,rgba(255,255,255,.025) 28px,rgba(255,255,255,.025) 29px)"}}/>
        {[{top:"45%",left:"48%",ico:"📍",anim:"pinBounce 2s ease-in-out infinite"},{top:"30%",left:"60%",ico:"🚗",anim:"float 2.5s ease-in-out infinite"},{top:"60%",left:"35%",ico:"🏍",anim:"float 3s ease-in-out infinite .5s"},{top:"38%",left:"25%",ico:"🚗",anim:"float 2.8s ease-in-out infinite 1s"}].map((m,i) => (
          <div key={i} style={{position:"absolute",top:m.top,left:m.left,fontSize:20,transform:"translate(-50%,-50%)",animation:m.anim}}>{m.ico}</div>
        ))}
        <div style={{position:"absolute",bottom:12,left:12,background:"rgba(8,8,16,.85)",backdropFilter:"blur(10px)",border:"1px solid #2a2a3a",borderRadius:99,padding:"5px 12px",fontSize:12,fontWeight:500,display:"flex",alignItems:"center",gap:6}}>
          <PulseDot /> 18 drivers nearby
        </div>
      </div>
    </div>
  );
}

// ─── RIDES SCREEN ─────────────────────────────────────────────────────────────
function RidesScreen({ rides, sortBy, setSortBy, filters, setFilters, showFilters, setShowFilters, onBook, pickup, dropoff, category, setCategory }) {
  const cats = [
    { id:"all", label:"All", icon:"search" },
    { id:"bike", label:"Bike", icon:"bike" },
    { id:"car", label:"Car", icon:"car" },
    { id:"public", label:"Public", icon:"bus" },
    { id:"women", label:"Women", icon:"women" },
  ];

  return (
    <div style={{animation:"fadeIn .3s ease"}}>
      {/* Header */}
      <div style={{padding:"18px 20px 12px",background:"#080810",position:"sticky",top:0,zIndex:10,borderBottom:"1px solid #1a1a28"}}>
        <div style={{fontFamily:"Syne,sans-serif",fontSize:20,fontWeight:800,marginBottom:12}}>Available Rides</div>
        {pickup && dropoff && (
          <div style={{display:"flex",alignItems:"center",gap:6,fontSize:13,color:"#8888aa",marginBottom:12}}>
            <Icon name="mapPin" size={12} color="#00e5a0" /> {pickup}
            <Icon name="arrowRight" size={12} color="#8888aa" />
            <Icon name="mapPin" size={12} color="#ff4d6d" /> {dropoff}
          </div>
        )}
        {/* Category chips */}
        <div style={{display:"flex",gap:7,overflowX:"auto",paddingBottom:2}}>
          {cats.map(c => (
            <button key={c.id} onClick={() => setCategory(c.id)} className="chip" style={{
              background:category===c.id ? (c.id==="women"?"rgba(255,110,180,.15)":"rgba(0,229,160,.12)") : "#1c1c28",
              border:`1px solid ${category===c.id ? (c.id==="women"?"#ff6eb4":"#00e5a0") : "#2a2a3a"}`,
              color:category===c.id ? (c.id==="women"?"#ff6eb4":"#00e5a0") : "#8888aa",
              borderRadius:99, padding:"5px 12px", fontSize:12, fontWeight:600,
              display:"flex", alignItems:"center", gap:5, flexShrink:0, transition:"all .2s"
            }}>
              <Icon name={c.icon} size={11} color={category===c.id ? (c.id==="women"?"#ff6eb4":"#00e5a0") : "#8888aa"} />
              {c.label}
            </button>
          ))}
        </div>
        {/* Sort & Filter */}
        <div style={{display:"flex",gap:8,marginTop:10}}>
          <div style={{display:"flex",gap:6,flex:1,overflowX:"auto"}}>
            {[["low","💸 Low→High"],["high","💰 High→Low"],["fast","⚡ Fastest"]].map(([s,l]) => (
              <button key={s} onClick={() => setSortBy(s)} style={{
                background:sortBy===s?"rgba(0,229,160,.12)":"#1c1c28",
                border:`1px solid ${sortBy===s?"#00e5a0":"#2a2a3a"}`,
                color:sortBy===s?"#00e5a0":"#8888aa",
                borderRadius:8, padding:"5px 12px", fontSize:11, fontWeight:600, whiteSpace:"nowrap", flexShrink:0, transition:"all .2s"
              }}>{l}</button>
            ))}
          </div>
          <button onClick={() => setShowFilters(!showFilters)} style={{background:showFilters?"rgba(123,94,248,.15)":"#1c1c28",border:`1px solid ${showFilters?"#7b5ef8":"#2a2a3a"}`,color:showFilters?"#7b5ef8":"#8888aa",borderRadius:8,padding:"5px 10px",flexShrink:0,display:"flex",alignItems:"center",gap:4,fontSize:11,fontWeight:600}}>
            <Icon name="filter" size={12} color={showFilters?"#7b5ef8":"#8888aa"} /> Filter
          </button>
        </div>
      </div>

      {/* Filter Panel */}
      {showFilters && (
        <div style={{margin:"0 20px",padding:"14px",background:"#12121a",border:"1px solid #2a2a3a",borderRadius:14,display:"grid",gridTemplateColumns:"1fr 1fr",gap:10,animation:"slideUp .2s ease"}}>
          {[
            { key:"vehicle", label:"Vehicle", opts:[["","All"],["bike","Bike"],["car","Car"],["suv","SUV"],["auto","Auto"],["bus","Bus"]] },
            { key:"brand", label:"Brand", opts:[["","Any"],["honda","Honda"],["toyota","Toyota"],["suzuki","Suzuki"],["hyundai","Hyundai"],["tata","Tata"]] },
            { key:"gender", label:"Driver", opts:[["","Any"],["women","Women ♀"],["men","Men"]] },
            { key:"ac", label:"AC", opts:[["","Any"],["yes","AC ❄️"],["no","Non-AC"]] },
          ].map(f => (
            <div key={f.key}>
              <div style={{fontSize:10,color:"#666688",fontWeight:700,textTransform:"uppercase",letterSpacing:.8,marginBottom:4}}>{f.label}</div>
              <select value={filters[f.key]} onChange={e => setFilters({...filters,[f.key]:e.target.value})}
                style={{background:"#1c1c28",border:"1px solid #2a2a3a",borderRadius:8,padding:"8px 10px",fontSize:12,color:"#f0f0f8",width:"100%"}}>
                {f.opts.map(([v,l]) => <option key={v} value={v}>{l}</option>)}
              </select>
            </div>
          ))}
        </div>
      )}

      {/* Ride Cards */}
      <div style={{padding:"12px 20px",display:"flex",flexDirection:"column",gap:12}}>
        {rides.length === 0 ? (
          <div style={{textAlign:"center",padding:"60px 0",color:"#8888aa"}}>
            <div style={{fontSize:48,marginBottom:12}}>🔍</div>
            <div style={{fontFamily:"Syne,sans-serif",fontSize:18,fontWeight:700,color:"#f0f0f8",marginBottom:6}}>No rides found</div>
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
      background:"#12121a",
      border:`1px solid ${r.womenOnly?"rgba(255,110,180,.25)":"#2a2a3a"}`,
      borderRadius:18,padding:"16px",cursor:"pointer",
      transition:"all .25s", animation:`slideUp .4s ease ${delay}s both`,
      position:"relative", overflow:"hidden"
    }}>
      {/* Top accent line */}
      <div style={{position:"absolute",top:0,left:0,right:0,height:3,background:r.womenOnly?"linear-gradient(90deg,#ff6eb4,#d63a8a)":"linear-gradient(90deg,#00e5a0,#7b5ef8)",borderRadius:"18px 18px 0 0"}}/>

      <div style={{display:"flex",alignItems:"center",justifyContent:"space-between",marginBottom:10}}>
        <div style={{display:"flex",alignItems:"center",gap:12}}>
          <div style={{width:46,height:46,borderRadius:14,background:r.womenOnly?"rgba(255,110,180,.1)":"rgba(0,229,160,.08)",border:`1px solid ${r.womenOnly?"rgba(255,110,180,.3)":"rgba(0,229,160,.2)"}`,display:"flex",alignItems:"center",justifyContent:"center"}}>
            <Icon name={r.icon} size={22} color={r.womenOnly?"#ff6eb4":"#00e5a0"} />
          </div>
          <div>
            <div style={{fontFamily:"Syne,sans-serif",fontSize:16,fontWeight:700}}>{r.name}</div>
            <div style={{fontSize:12,color:"#8888aa",marginTop:2,display:"flex",alignItems:"center",gap:8}}>
              <span>🏷 {r.brand}</span>
              <span>💺 {r.seats}</span>
              {r.ac && <span>❄️ AC</span>}
            </div>
          </div>
        </div>
        <div style={{textAlign:"right"}}>
          <div style={{fontFamily:"Syne,sans-serif",fontSize:26,fontWeight:800,color:r.womenOnly?"#ff6eb4":"#00e5a0",lineHeight:1}}>₹{r.fare}</div>
          <div style={{fontSize:12,color:"#8888aa",marginTop:2}}>⏱ {r.eta} min</div>
        </div>
      </div>

      {/* Badges */}
      <div style={{display:"flex",gap:6,flexWrap:"wrap",marginBottom:12}}>
        {r.womenOnly && <Badge label="♀ Women Only" color="#ff6eb4" bg="rgba(255,110,180,.1)" />}
        {r.shared && <Badge label="🤝 Shared" color="#7b5ef8" bg="rgba(123,94,248,.1)" />}
        {r.driver.gender === "women" && <Badge label="♀ Woman Driver" color="#ff6eb4" bg="rgba(255,110,180,.1)" />}
      </div>

      {/* Driver */}
      <div style={{display:"flex",alignItems:"center",gap:10,paddingTop:10,borderTop:"1px solid #1c1c28"}}>
        <div style={{width:34,height:34,borderRadius:99,background:r.driver.color+"33",border:`2px solid ${r.driver.color}55`,display:"flex",alignItems:"center",justifyContent:"center",fontFamily:"Syne,sans-serif",fontSize:12,fontWeight:700,color:r.driver.color,flexShrink:0}}>
          {r.driver.avatar}
        </div>
        <div style={{flex:1}}>
          <div style={{fontSize:13,fontWeight:500}}>{r.driver.name}</div>
          <div style={{fontSize:12,color:"#8888aa",display:"flex",alignItems:"center",gap:4}}>
            <Icon name="star" size={11} color="#f59e0b" style={{fill:"#f59e0b"}} />
            {r.driver.rating} · {r.driver.trips.toLocaleString()} trips
          </div>
        </div>
        <button onClick={e => {e.stopPropagation();}} style={{background:r.womenOnly?"linear-gradient(135deg,#ff6eb4,#d63a8a)":"linear-gradient(135deg,#00e5a0,#00b87a)",color:r.womenOnly?"#fff":"#080810",border:"none",borderRadius:9,padding:"8px 14px",fontSize:12,fontWeight:800,transition:"all .2s"}}>
          Book
        </button>
      </div>
    </div>
  );
}

// ─── SHARE SCREEN ──────────────────────────────────────────────────────────────
function ShareScreen({ womenShare, setWomenShare, maxShare, setMaxShare, onSearch }) {
  return (
    <div style={{padding:"20px",animation:"fadeIn .3s ease"}}>
      <div style={{fontFamily:"Syne,sans-serif",fontSize:22,fontWeight:800,marginBottom:4}}>Share a Ride</div>
      <div style={{fontSize:14,color:"#8888aa",marginBottom:20}}>Split fare with co-riders on the same route</div>

      {/* How it works */}
      <div style={{display:"flex",gap:0,marginBottom:20,background:"#12121a",border:"1px solid #2a2a3a",borderRadius:16,overflow:"hidden"}}>
        {[["1","Find","Match with nearby riders"],["2","Confirm","Agree on route & fare"],["3","Ride","Save up to 40% fare"]].map(([n,t,d],i) => (
          <div key={n} style={{flex:1,padding:"14px 10px",textAlign:"center",borderRight:i<2?"1px solid #2a2a3a":"none"}}>
            <div style={{width:28,height:28,borderRadius:99,background:"linear-gradient(135deg,#00e5a0,#7b5ef8)",display:"flex",alignItems:"center",justifyContent:"center",margin:"0 auto 6px",fontFamily:"Syne,sans-serif",fontSize:13,fontWeight:800,color:"#080810"}}>{n}</div>
            <div style={{fontFamily:"Syne,sans-serif",fontSize:12,fontWeight:700,marginBottom:2}}>{t}</div>
            <div style={{fontSize:11,color:"#8888aa"}}>{d}</div>
          </div>
        ))}
      </div>

      {/* Input */}
      <div style={{background:"#12121a",border:"1px solid #2a2a3a",borderRadius:18,padding:16,marginBottom:14}}>
        <LocationInput icon="mapPin" iconColor="#00e5a0" placeholder="Pickup location" />
        <div style={{width:2,height:12,background:"linear-gradient(#00e5a0,#ff4d6d)",margin:"3px 0 3px 18px",borderRadius:99}}/>
        <LocationInput icon="mapPin" iconColor="#ff4d6d" placeholder="Destination" />
        <div style={{marginTop:14,display:"flex",flexDirection:"column",gap:10}}>
          <Toggle label="Women-only shared ride ♀" checked={womenShare} onChange={setWomenShare} accent="#ff6eb4" />
          <Toggle label="Max 2 co-riders only" checked={maxShare} onChange={setMaxShare} />
        </div>
      </div>

      <div style={{background:"rgba(0,229,160,.05)",border:"1px solid rgba(0,229,160,.15)",borderRadius:14,padding:"12px 14px",marginBottom:14,display:"flex",gap:10,alignItems:"flex-start"}}>
        <Icon name="shield" size={16} color="#00e5a0" />
        <div>
          <div style={{fontSize:13,fontWeight:600,color:"#00e5a0",marginBottom:2}}>Safe Sharing</div>
          <div style={{fontSize:12,color:"#8888aa"}}>All co-riders are verified. Women-only mode pairs female passengers with female drivers only.</div>
        </div>
      </div>

      <button onClick={onSearch} style={{width:"100%",background:"linear-gradient(135deg,#7b5ef8,#5b3fd8)",color:"#fff",border:"none",borderRadius:12,padding:"14px",fontFamily:"Syne,sans-serif",fontSize:15,fontWeight:800,display:"flex",alignItems:"center",justifyContent:"center",gap:8}}>
        <Icon name="search" size={16} color="#fff" /> Find Shared Rides
      </button>

      {/* Active share rides */}
      <div style={{marginTop:20}}>
        <div style={{fontFamily:"Syne,sans-serif",fontSize:15,fontWeight:700,marginBottom:10}}>Available Shared Rides</div>
        {RIDES.filter(r => r.shared).map((r,i) => (
          <div key={r.id} style={{background:"#12121a",border:"1px solid #2a2a3a",borderRadius:14,padding:"12px 14px",marginBottom:10,display:"flex",alignItems:"center",gap:12}}>
            <div style={{width:40,height:40,borderRadius:10,background:"rgba(123,94,248,.1)",display:"flex",alignItems:"center",justifyContent:"center",flexShrink:0}}>
              <Icon name={r.icon} size={20} color="#7b5ef8" />
            </div>
            <div style={{flex:1}}>
              <div style={{fontFamily:"Syne,sans-serif",fontSize:14,fontWeight:700}}>{r.name}</div>
              <div style={{fontSize:12,color:"#8888aa"}}>⏱ {r.eta} min · {r.driver.name} · ⭐{r.driver.rating}</div>
            </div>
            <div style={{textAlign:"right"}}>
              <div style={{fontFamily:"Syne,sans-serif",fontSize:18,fontWeight:800,color:"#7b5ef8"}}>₹{r.fare}</div>
              <div style={{fontSize:11,color:"#8888aa"}}>per seat</div>
            </div>
          </div>
        ))}
      </div>
    </div>
  );
}

// ─── SAFETY SCREEN ────────────────────────────────────────────────────────────
function SafetyScreen({ onSOS }) {
  return (
    <div style={{padding:"20px",animation:"fadeIn .3s ease"}}>
      <div style={{fontFamily:"Syne,sans-serif",fontSize:22,fontWeight:800,marginBottom:4}}>Safety Center</div>
      <div style={{fontSize:14,color:"#8888aa",marginBottom:20}}>Your safety is our top priority</div>

      {/* SOS Button */}
      <div style={{textAlign:"center",padding:"28px 0",background:"#12121a",border:"1px solid rgba(255,77,109,.2)",borderRadius:20,marginBottom:16,position:"relative",overflow:"hidden"}}>
        <div style={{fontSize:13,color:"#8888aa",marginBottom:16}}>Emergency? Tap SOS immediately</div>
        <div style={{position:"relative",display:"inline-block"}} onClick={onSOS}>
          <div style={{position:"absolute",inset:-20,borderRadius:99,background:"rgba(255,77,109,.1)",animation:"ripple 1.5s ease-in-out infinite"}}/>
          <div style={{position:"absolute",inset:-10,borderRadius:99,background:"rgba(255,77,109,.15)",animation:"ripple 1.5s ease-in-out infinite .3s"}}/>
          <button style={{width:100,height:100,borderRadius:99,background:"linear-gradient(135deg,#ff4d6d,#ff0040)",border:"none",color:"#fff",fontFamily:"Syne,sans-serif",fontSize:18,fontWeight:900,letterSpacing:2,position:"relative",boxShadow:"0 8px 32px rgba(255,77,109,.5)",cursor:"pointer"}}>
            SOS
          </button>
        </div>
        <div style={{fontSize:12,color:"#666688",marginTop:20}}>Sends alert to emergency contacts & police</div>
      </div>

      {/* Safety Features */}
      {[
        {icon:"shield",color:"#00e5a0",title:"Verified Drivers",desc:"All drivers are background-checked and ID-verified before onboarding."},
        {icon:"phone",color:"#7b5ef8",title:"Share Trip",desc:"Share your live location and trip details with trusted contacts."},
        {icon:"women",color:"#ff6eb4",title:"Women Safety Mode",desc:"Female passengers matched with female drivers. Route monitored live."},
        {icon:"location",color:"#f59e0b",title:"Live Tracking",desc:"Real-time GPS tracking shared with emergency contacts automatically."},
        {icon:"bell",color:"#06b6d4",title:"Ride Alerts",desc:"Get alerts if your route deviates or ride takes unusually long."},
      ].map(f => (
        <div key={f.title} style={{display:"flex",gap:14,background:"#12121a",border:"1px solid #2a2a3a",borderRadius:14,padding:"14px",marginBottom:10}}>
          <div style={{width:42,height:42,borderRadius:12,background:f.color+"15",display:"flex",alignItems:"center",justifyContent:"center",flexShrink:0}}>
            <Icon name={f.icon} size={20} color={f.color} />
          </div>
          <div>
            <div style={{fontFamily:"Syne,sans-serif",fontSize:14,fontWeight:700,marginBottom:3}}>{f.title}</div>
            <div style={{fontSize:13,color:"#8888aa",lineHeight:1.5}}>{f.desc}</div>
          </div>
        </div>
      ))}

      {/* Emergency Contacts */}
      <div style={{background:"#12121a",border:"1px solid #2a2a3a",borderRadius:14,padding:14,marginTop:4}}>
        <div style={{fontFamily:"Syne,sans-serif",fontSize:14,fontWeight:700,marginBottom:10,display:"flex",justifyContent:"space-between",alignItems:"center"}}>
          Emergency Contacts
          <button style={{background:"rgba(0,229,160,.1)",border:"1px solid rgba(0,229,160,.2)",color:"#00e5a0",borderRadius:8,padding:"4px 10px",fontSize:12,fontWeight:600,display:"flex",alignItems:"center",gap:4}}>
            <Icon name="plus" size={11} color="#00e5a0" /> Add
          </button>
        </div>
        {[{name:"Mom",phone:"+91 98765 43210"},{name:"Rahul (Friend)",phone:"+91 87654 32109"}].map(c => (
          <div key={c.name} style={{display:"flex",justifyContent:"space-between",alignItems:"center",padding:"8px 0",borderBottom:"1px solid #1a1a28"}}>
            <div>
              <div style={{fontSize:13,fontWeight:500}}>{c.name}</div>
              <div style={{fontSize:12,color:"#8888aa"}}>{c.phone}</div>
            </div>
            <Icon name="phone" size={14} color="#00e5a0" />
          </div>
        ))}
      </div>
    </div>
  );
}

// ─── PROFILE SCREEN ───────────────────────────────────────────────────────────
function ProfileScreen({ history }) {
  return (
    <div style={{padding:"20px",animation:"fadeIn .3s ease"}}>
      {/* Profile Header */}
      <div style={{background:"linear-gradient(135deg,rgba(123,94,248,.15),rgba(0,229,160,.1))",border:"1px solid #2a2a3a",borderRadius:20,padding:"20px",marginBottom:16,textAlign:"center"}}>
        <div style={{width:72,height:72,borderRadius:99,background:"linear-gradient(135deg,#7b5ef8,#00e5a0)",display:"flex",alignItems:"center",justifyContent:"center",margin:"0 auto 12px",fontFamily:"Syne,sans-serif",fontSize:24,fontWeight:800,color:"#080810"}}>AJ</div>
        <div style={{fontFamily:"Syne,sans-serif",fontSize:20,fontWeight:800}}>Arjun Joshi</div>
        <div style={{fontSize:13,color:"#8888aa",marginTop:2}}>+91 98765 43210</div>
        <div style={{display:"flex",gap:20,justifyContent:"center",marginTop:14}}>
          {[["42","Rides"],["4.9","Rating"],["₹2.4k","Saved"]].map(([v,l]) => (
            <div key={l} style={{textAlign:"center"}}>
              <div style={{fontFamily:"Syne,sans-serif",fontSize:20,fontWeight:800,color:"#00e5a0"}}>{v}</div>
              <div style={{fontSize:11,color:"#8888aa"}}>{l}</div>
            </div>
          ))}
        </div>
      </div>

      {/* Wallet */}
      <div style={{background:"linear-gradient(135deg,#1a1a2e,#16213e)",border:"1px solid rgba(123,94,248,.3)",borderRadius:16,padding:"16px",marginBottom:14,display:"flex",justifyContent:"space-between",alignItems:"center"}}>
        <div>
          <div style={{fontSize:12,color:"#8888aa",marginBottom:3}}>ZIPP Wallet</div>
          <div style={{fontFamily:"Syne,sans-serif",fontSize:26,fontWeight:800,color:"#f59e0b"}}>₹ 840.00</div>
        </div>
        <div style={{display:"flex",gap:8}}>
          <button style={{background:"rgba(245,158,11,.15)",border:"1px solid rgba(245,158,11,.3)",color:"#f59e0b",borderRadius:10,padding:"8px 14px",fontSize:12,fontWeight:700}}>Add Money</button>
        </div>
      </div>

      {/* Ride History */}
      <div style={{fontFamily:"Syne,sans-serif",fontSize:15,fontWeight:700,marginBottom:10,display:"flex",alignItems:"center",gap:6}}>
        <Icon name="history" size={15} color="#7b5ef8" /> Recent Rides
      </div>
      {history.map(h => (
        <div key={h.id} style={{background:"#12121a",border:"1px solid #2a2a3a",borderRadius:14,padding:"12px 14px",marginBottom:10,display:"flex",gap:12,alignItems:"center"}}>
          <div style={{width:38,height:38,borderRadius:10,background:"rgba(0,229,160,.08)",border:"1px solid rgba(0,229,160,.15)",display:"flex",alignItems:"center",justifyContent:"center",flexShrink:0}}>
            <Icon name={h.type} size={18} color="#00e5a0" />
          </div>
          <div style={{flex:1}}>
            <div style={{fontSize:13,fontWeight:500,marginBottom:2}}>{h.from} → {h.to}</div>
            <div style={{fontSize:12,color:"#8888aa"}}>{h.date}</div>
          </div>
          <div>
            <div style={{fontFamily:"Syne,sans-serif",fontSize:16,fontWeight:700,color:"#00e5a0",textAlign:"right"}}>₹{h.fare}</div>
            <div style={{fontSize:11,color:"#8888aa",textAlign:"right"}}>{h.status}</div>
          </div>
        </div>
      ))}

      {/* Settings Menu */}
      <div style={{background:"#12121a",border:"1px solid #2a2a3a",borderRadius:16,overflow:"hidden",marginTop:6}}>
        {[
          {icon:"edit",label:"Edit Profile"},
          {icon:"wallet",label:"Payment Methods"},
          {icon:"bell",label:"Notifications"},
          {icon:"shield",label:"Privacy & Safety"},
          {icon:"settings",label:"Settings"},
          {icon:"logout",label:"Sign Out",color:"#ff4d6d"},
        ].map((item,i) => (
          <div key={item.label} style={{display:"flex",alignItems:"center",gap:12,padding:"13px 16px",borderBottom:i<5?"1px solid #1a1a28":"none",cursor:"pointer"}}>
            <Icon name={item.icon} size={17} color={item.color||"#8888aa"} />
            <span style={{flex:1,fontSize:14,fontWeight:500,color:item.color||"#f0f0f8"}}>{item.label}</span>
            <Icon name="chevDown" size={14} color="#444466" style={{transform:"rotate(-90deg)"}} />
          </div>
        ))}
      </div>
    </div>
  );
}

// ─── BOTTOM NAV ───────────────────────────────────────────────────────────────
function BottomNav({ tab, setTab }) {
  const items = [
    { id:"home", icon:"home", label:"Home" },
    { id:"rides", icon:"car", label:"Rides" },
    { id:"share", icon:"share", label:"Share" },
    { id:"safety", icon:"safety", label:"Safety" },
    { id:"profile", icon:"user", label:"Profile" },
  ];
  return (
    <div style={{position:"fixed",bottom:0,left:"50%",transform:"translateX(-50%)",width:"100%",maxWidth:430,background:"rgba(8,8,16,.95)",backdropFilter:"blur(20px)",borderTop:"1px solid #1a1a28",display:"flex",zIndex:50,paddingBottom:"env(safe-area-inset-bottom,0px)"}}>
      {items.map(item => (
        <button key={item.id} onClick={() => setTab(item.id)} style={{flex:1,background:"transparent",border:"none",padding:"10px 0 8px",display:"flex",flexDirection:"column",alignItems:"center",gap:3,transition:"all .2s"}}>
          <div style={{width:36,height:36,borderRadius:10,background:tab===item.id?"rgba(0,229,160,.12)":"transparent",display:"flex",alignItems:"center",justifyContent:"center",transition:"all .2s"}}>
            <Icon name={item.icon} size={19} color={tab===item.id?"#00e5a0":"#555577"} />
          </div>
          <span style={{fontSize:10,fontWeight:600,color:tab===item.id?"#00e5a0":"#555577",fontFamily:"Syne,sans-serif",transition:"all .2s"}}>{item.label}</span>
        </button>
      ))}
    </div>
  );
}

// ─── MODALS ───────────────────────────────────────────────────────────────────
function ConfirmModal({ ride: r, pickup, dropoff, onClose, onConfirm }) {
  return (
    <div style={{position:"fixed",inset:0,background:"rgba(0,0,0,.8)",backdropFilter:"blur(12px)",zIndex:200,display:"flex",alignItems:"flex-end"}}>
      <div style={{width:"100%",maxWidth:430,margin:"0 auto",background:"#12121a",borderRadius:"24px 24px 0 0",padding:"24px",animation:"modalIn .3s ease",maxHeight:"90vh",overflowY:"auto"}}>
        <div style={{width:40,height:4,borderRadius:99,background:"#2a2a3a",margin:"0 auto 20px"}}/>
        <div style={{fontFamily:"Syne,sans-serif",fontSize:20,fontWeight:800,marginBottom:16}}>Confirm Ride</div>
        <div style={{background:"#1c1c28",borderRadius:14,overflow:"hidden",marginBottom:16}}>
          {[
            ["Ride", `${r.name}`],
            ["From", pickup||"Current Location"],
            ["To", dropoff||"Destination"],
            ["Driver", r.driver.name],
            ["ETA", `${r.eta} min`],
            ["Fare", `₹${r.fare}`, true],
            ...(r.womenOnly?[["Type","♀ Women Only"]]:r.shared?[["Type","🤝 Shared Ride"]]:[]),
          ].map(([k,v,accent],i,arr) => (
            <div key={k} style={{display:"flex",justifyContent:"space-between",alignItems:"center",padding:"11px 14px",borderBottom:i<arr.length-1?"1px solid #2a2a3a":"none"}}>
              <span style={{fontSize:13,color:"#8888aa"}}>{k}</span>
              <span style={{fontSize:13,fontWeight:600,color:accent?"#00e5a0":"#f0f0f8"}}>{v}</span>
            </div>
          ))}
        </div>
        <div style={{display:"flex",gap:10}}>
          <button onClick={onClose} style={{flex:1,background:"#1c1c28",border:"1px solid #2a2a3a",color:"#f0f0f8",borderRadius:12,padding:"13px",fontSize:14,fontWeight:700}}>Cancel</button>
          <button onClick={onConfirm} style={{flex:2,background:"linear-gradient(135deg,#00e5a0,#00b87a)",color:"#080810",border:"none",borderRadius:12,padding:"13px",fontSize:14,fontWeight:800,display:"flex",alignItems:"center",justifyContent:"center",gap:8}}>
            Confirm Booking <Icon name="arrowRight" size={16} color="#080810" />
          </button>
        </div>
      </div>
    </div>
  );
}

function SuccessModal({ ride: r, etaCount, onClose, onSOS }) {
  return (
    <div style={{position:"fixed",inset:0,background:"rgba(0,0,0,.85)",backdropFilter:"blur(14px)",zIndex:200,display:"flex",alignItems:"flex-end"}}>
      <div style={{width:"100%",maxWidth:430,margin:"0 auto",background:"#12121a",borderRadius:"24px 24px 0 0",padding:"28px",animation:"modalIn .3s ease"}}>
        <div style={{textAlign:"center",marginBottom:20}}>
          <div style={{fontSize:56,animation:"float 2s ease-in-out infinite",display:"block"}}>✅</div>
          <div style={{fontFamily:"Syne,sans-serif",fontSize:22,fontWeight:800,marginTop:8}}>Ride Confirmed!</div>
          <div style={{fontSize:14,color:"#8888aa",marginTop:4}}>Your driver is on the way</div>
        </div>
        <div style={{background:"#1c1c28",borderRadius:16,padding:"14px",marginBottom:14,display:"flex",alignItems:"center",gap:12}}>
          <div style={{width:46,height:46,borderRadius:99,background:r.driver.color+"33",border:`2px solid ${r.driver.color}55`,display:"flex",alignItems:"center",justifyContent:"center",fontFamily:"Syne,sans-serif",fontSize:14,fontWeight:800,color:r.driver.color,flexShrink:0}}>
            {r.driver.avatar}
          </div>
          <div style={{flex:1}}>
            <div style={{fontFamily:"Syne,sans-serif",fontSize:15,fontWeight:700}}>{r.driver.name}</div>
            <div style={{fontSize:12,color:"#8888aa"}}>⭐ {r.driver.rating} · {r.name} · {r.brand}</div>
          </div>
          <div style={{textAlign:"right"}}>
            <div style={{fontFamily:"Syne,sans-serif",fontSize:34,fontWeight:900,color:"#00e5a0",lineHeight:1}}>{etaCount}</div>
            <div style={{fontSize:11,color:"#8888aa"}}>min</div>
          </div>
        </div>
        <div style={{display:"flex",gap:10,marginBottom:12}}>
          <button style={{flex:1,background:"rgba(0,229,160,.1)",border:"1px solid rgba(0,229,160,.25)",color:"#00e5a0",borderRadius:12,padding:"11px",fontSize:13,fontWeight:700,display:"flex",alignItems:"center",justifyContent:"center",gap:6}}>
            <Icon name="phone" size={14} color="#00e5a0" /> Call Driver
          </button>
          <button style={{flex:1,background:"rgba(123,94,248,.1)",border:"1px solid rgba(123,94,248,.25)",color:"#7b5ef8",borderRadius:12,padding:"11px",fontSize:13,fontWeight:700,display:"flex",alignItems:"center",justifyContent:"center",gap:6}}>
            <Icon name="share" size={14} color="#7b5ef8" /> Share Trip
          </button>
        </div>
        <button onClick={onSOS} style={{width:"100%",background:"rgba(255,77,109,.1)",border:"1px solid rgba(255,77,109,.3)",color:"#ff4d6d",borderRadius:12,padding:"11px",fontSize:13,fontWeight:700,display:"flex",alignItems:"center",justifyContent:"center",gap:6,marginBottom:12}}>
          <Icon name="sos" size={14} color="#ff4d6d" /> SOS Emergency
        </button>
        <button onClick={onClose} style={{width:"100%",background:"linear-gradient(135deg,#00e5a0,#00b87a)",color:"#080810",border:"none",borderRadius:12,padding:"13px",fontFamily:"Syne,sans-serif",fontSize:14,fontWeight:800}}>
          Track Live →
        </button>
      </div>
    </div>
  );
}

function SOSModal({ onClose }) {
  const [sent, setSent] = useState(false);
  return (
    <div style={{position:"fixed",inset:0,background:"rgba(0,0,0,.9)",backdropFilter:"blur(16px)",zIndex:300,display:"flex",alignItems:"center",justifyContent:"center",padding:20}}>
      <div style={{background:"#12121a",border:"2px solid rgba(255,77,109,.4)",borderRadius:24,padding:"28px",width:"100%",maxWidth:360,textAlign:"center",animation:"modalIn .2s ease"}}>
        {!sent ? (
          <>
            <div style={{fontSize:48,marginBottom:12,animation:"float 1s ease-in-out infinite"}}>🚨</div>
            <div style={{fontFamily:"Syne,sans-serif",fontSize:22,fontWeight:800,color:"#ff4d6d",marginBottom:6}}>Emergency SOS</div>
            <div style={{fontSize:14,color:"#8888aa",marginBottom:20}}>This will alert your emergency contacts and local authorities with your live location.</div>
            <button onClick={() => setSent(true)} style={{width:"100%",background:"linear-gradient(135deg,#ff4d6d,#ff0040)",color:"#fff",border:"none",borderRadius:14,padding:"16px",fontFamily:"Syne,sans-serif",fontSize:16,fontWeight:900,letterSpacing:2,marginBottom:10,boxShadow:"0 8px 32px rgba(255,77,109,.5)"}}>
              SEND SOS NOW
            </button>
            <button onClick={onClose} style={{width:"100%",background:"transparent",border:"1px solid #2a2a3a",color:"#8888aa",borderRadius:12,padding:"12px",fontSize:14,fontWeight:600}}>Cancel</button>
          </>
        ) : (
          <>
            <div style={{fontSize:48,marginBottom:12}}>✅</div>
            <div style={{fontFamily:"Syne,sans-serif",fontSize:20,fontWeight:800,color:"#00e5a0",marginBottom:6}}>SOS Sent!</div>
            <div style={{fontSize:14,color:"#8888aa",marginBottom:6}}>Emergency contacts and authorities have been alerted.</div>
            <div style={{fontSize:13,color:"#8888aa",marginBottom:20}}>Help is on the way. Stay calm and stay in the vehicle.</div>
            <button onClick={onClose} style={{width:"100%",background:"linear-gradient(135deg,#00e5a0,#00b87a)",color:"#080810",border:"none",borderRadius:12,padding:"13px",fontFamily:"Syne,sans-serif",fontSize:14,fontWeight:800}}>Close</button>
          </>
        )}
      </div>
    </div>
  );
}

// ─── SMALL COMPONENTS ─────────────────────────────────────────────────────────
function LocationInput({ icon, iconColor, value, onChange, placeholder }) {
  return (
    <div style={{display:"flex",alignItems:"center",gap:10,background:"#1c1c28",border:"1px solid #2a2a3a",borderRadius:10,padding:"11px 13px",transition:"border-color .2s"}}>
      <Icon name={icon} size={15} color={iconColor} />
      <input value={value||""} onChange={e => onChange && onChange(e.target.value)} placeholder={placeholder} style={{color:"#f0f0f8",fontSize:14}} />
    </div>
  );
}

function Toggle({ label, checked, onChange, accent = "#00e5a0" }) {
  return (
    <label style={{display:"flex",alignItems:"center",gap:10,cursor:"pointer",fontSize:13,color:"#f0f0f8"}}>
      <div onClick={() => onChange(!checked)} style={{width:42,height:24,borderRadius:99,background:checked?`${accent}22`:"#1c1c28",border:`1px solid ${checked?accent:"#2a2a3a"}`,position:"relative",transition:"all .25s",flexShrink:0}}>
        <div style={{position:"absolute",top:3,left:checked?19:3,width:16,height:16,borderRadius:99,background:checked?accent:"#555577",transition:"all .25s"}}/>
      </div>
      {label}
    </label>
  );
}

function Badge({ label, color, bg }) {
  return (
    <span style={{background:bg,border:`1px solid ${color}55`,color:color,borderRadius:99,padding:"3px 10px",fontSize:11,fontWeight:600,display:"inline-flex",alignItems:"center"}}>
      {label}
    </span>
  );
}

function PulseDot({ color = "#00e5a0" }) {
  return (
    <span style={{display:"inline-block",width:7,height:7,borderRadius:99,background:color,animation:"pulse 1.5s ease-in-out infinite"}}/>
  );
}

function IconBtn({ icon, onClick }) {
  return (
    <button onClick={onClick} style={{width:38,height:38,borderRadius:10,background:"#12121a",border:"1px solid #2a2a3a",display:"flex",alignItems:"center",justifyContent:"center",transition:"all .2s"}}>
      <Icon name={icon} size={16} color="#8888aa" />
    </button>
  );
}
