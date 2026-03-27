
const RIDES = [
  { id:1, name:"QuickBike", type:"bike", brand:"Honda", seats:1, fare:49, eta:3, ac:false, shared:false, womenOnly:false, icon:"bike", driver:{name:"Ravi K.",rating:4.8,gender:"men",trips:1240,avatar:"RK",color:"#1D6FA4"}},
  { id:2, name:"AutoRide", type:"auto", brand:"Bajaj", seats:3, fare:79, eta:5, ac:false, shared:false, womenOnly:false, icon:"auto", driver:{name:"Suresh M.",rating:4.6,gender:"men",trips:980,avatar:"SM",color:"#f59e0b"}},
  { id:3, name:"MiniCab", type:"car", brand:"Suzuki", seats:4, fare:119, eta:6, ac:true, shared:false, womenOnly:false, icon:"car", driver:{name:"Priya S.",rating:4.9,gender:"women",trips:2100,avatar:"PS",color:"#ec4899"}},
  { id:4, name:"ShareGo", type:"car", brand:"Hyundai", seats:4, fare:89, eta:8, ac:true, shared:true, womenOnly:false, icon:"car", driver:{name:"Amit R.",rating:4.7,gender:"men",trips:1560,avatar:"AR",color:"#06b6d4"}},
  { id:5, name:"SafeHer Bike", type:"bike", brand:"Honda", seats:1, fare:59, eta:4, ac:false, shared:false, womenOnly:true, icon:"bike", driver:{name:"Neha G.",rating:5.0,gender:"women",trips:890,avatar:"NG",color:"#ff4d6d"}},
  { id:6, name:"ComfortCar", type:"car", brand:"Toyota", seats:4, fare:179, eta:7, ac:true, shared:false, womenOnly:false, icon:"car", driver:{name:"Karan T.",rating:4.5,gender:"men",trips:3200,avatar:"KT",color:"#1A5C8A"}},
  { id:7, name:"SafeHer Cab", type:"car", brand:"Tata", seats:4, fare:149, eta:9, ac:true, shared:false, womenOnly:true, icon:"car", driver:{name:"Anjali M.",rating:4.9,gender:"women",trips:1780,avatar:"AM",color:"#ff4d6d"}},
  { id:8, name:"CityBus", type:"bus", brand:"Tata", seats:30, fare:25, eta:12, ac:false, shared:true, womenOnly:false, icon:"bus", driver:{name:"Mohan D.",rating:4.3,gender:"men",trips:5400,avatar:"MD",color:"#155F8E"}},
  { id:9, name:"PremiumSUV", type:"suv", brand:"Toyota", seats:6, fare:299, eta:10, ac:true, shared:false, womenOnly:false, icon:"car", driver:{name:"Vikram S.",rating:4.8,gender:"men",trips:2900,avatar:"VS",color:"#f59e0b"}},
  { id:10, name:"ShareHer", type:"car", brand:"Suzuki", seats:4, fare:99, eta:6, ac:true, shared:true, womenOnly:true, icon:"car", driver:{name:"Deepa K.",rating:4.9,gender:"women",trips:1340,avatar:"DK",color:"#ec4899"}},
];

const PROMO = [
  { code:"ZIPP20", desc:"20% off first 3 rides", color:"#1D6FA4" },
  { code:"SHARE50", desc:"50% off shared rides", color:"#2872A1" },
  { code:"SAFEHER", desc:"Free ride for women drivers", color:"#ff4d6d" },
];

const HISTORY = [
  { id:"BK001", date:"Today, 2:30 PM", from:"MG Road", to:"Koramangala", fare:149, status:"completed", type:"car" },
  { id:"BK002", date:"Yesterday, 9:15 AM", from:"Home", to:"Office", fare:59, status:"completed", type:"bike" },
  { id:"BK003", date:"Mon, 8:00 AM", from:"Airport", to:"Hotel", fare:299, status:"completed", type:"car" },
];

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
  const [modal, setModal] = useState(null);
  const [bookedRide, setBookedRide] = useState(null);
  const [womenShare, setWomenShare] = useState(false);
  const [maxShare, setMaxShare] = useState(false);
  const [activeRide, setActiveRide] = useState(null);
  const [etaCount, setEtaCount] = useState(0);
  const [splashDone, setSplashDone] = useState(false);
  const timerRef = useRef(null);

  useEffect(() => {
    const t = setTimeout(() => { setScreen("home"); setSplashDone(true); }, 2400);
    return () => clearTimeout(t);
  }, []);

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

  if (screen === "splash") return (
    <div style={{
      position:"fixed", inset:0, background:"#0D2137",
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
          <span style={{color:"#2872A1"}}>Z</span>
          <span style={{color:"#FFFFFF"}}>IPP</span>
        </div>
        <div style={{fontSize:12,letterSpacing:5,color:"#5A7A8F",marginTop:8,textTransform:"uppercase"}}>
          Ride · Share · Arrive
        </div>
      </div>
      <div style={{width:180,height:3,background:"#1A3A52",borderRadius:99,overflow:"hidden",marginTop:8}}>
        <div style={{height:"100%",width:0,background:"linear-gradient(90deg,#2872A1,#1D6FA4)",borderRadius:99,animation:"splashBar 2s ease forwards"}}/>
      </div>
    </div>
  );

  return (
    <div style={{
      maxWidth:430, margin:"0 auto", minHeight:"100vh",
      background:"#EAF2F8", color:"#0D2137",
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
        input, select { background: transparent; border: none; outline: none; color: #0D2137; font-family: 'DM Sans', sans-serif; width: 100%; font-size: 14px; }
        select option { background: #CBDDE9; color: #0D2137; }
        button { cursor: pointer; font-family: 'Syne', sans-serif; }
        ::-webkit-scrollbar { display: none; }
        .ride-card:hover { transform: translateY(-2px); }
        .chip:hover { opacity: .85; }
        .tab-btn.active-tab { color: #2872A1 !important; }
      `}</style>

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

      <BottomNav tab={tab} setTab={setTab} />

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
