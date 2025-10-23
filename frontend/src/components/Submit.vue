<script setup>
import { onMounted, ref } from "vue";
import { postMeal, postMsgSoMany } from "./api.js";
import { useMessage } from "naive-ui";

defineProps({
  msg: String,
});

const message = useMessage();
const meal = ref("");
const mealInput = ref("");
const mealShow = ref("");

onMounted(() => {
  // mealShow.value = localStorage.getItem("lastMeal") || "";
});

function submit() {
  if (msgSoMany()) return;

  if (mealInput.value.trim() === "") {
    message.error("饿死我算了，啥都不给我吃");
    return;
  }

  meal.value = mealInput.value;
  mealInput.value = "";
  submitMeal();
}

async function submitMeal() {
  let result = "";
  const subing = message.loading("提交中...", { duration: 0 });
  try {
    const res = await postMeal(meal.value);
    result = res.status || "unknown";
  } catch (err) {
    result = "提交失败";
  }
  if (result == "recorded") {
    mealShow.value = meal.value;
    console.log("Meal submitted successfully");
    localStorage.setItem("lastMeal", meal.value);
    message.success("提交成功！");
  } else {
    alert("提交失败，错误信息：" + result);
  }
  subing.destroy();
}

let submitCount = 0;
setInterval(() => {
  submitCount--;
  if (submitCount < 0) submitCount = 0;
}, 2000);
setInterval(() => {
  submitCount = 1;
}, 60000);
function msgSoMany() {
  console.log("Submit count:", submitCount);
  if (submitCount >= 5) {
    message.warning("再玩就玩坏啦！");
    postMsgSoMany();
    return true;
  }
  submitCount++;
  return false;
}
</script>

<template>
  <transition-group name="fade-slide" tag="div" class="submit">
    <h2 id="msg" key="msg">{{ msg }}</h2>

    <div class="input-block" key="input">
      <input
        @keyup.enter="submit"
        v-model="mealInput"
        type="text"
        placeholder="在此处输入菜品或外卖链接"
        id="mealInput"
        style="font-family: initial"
      />
      <n-button type="primary" @click="submit" id="submitBtn">投！</n-button>
    </div>

    <div v-if="mealShow !== ''" class="menu" key="menu">
      <span class="meal">{{ mealShow }}</span>
    </div>
  </transition-group>
</template>

<style scoped>
.submit {
  font-size: medium;
}
h2#msg {
  text-align: center;
  font-size: 2em;
  color: #d8d8d8;
  margin-top: 20px;
}

input#mealInput {
  width: 100%;
  max-width: 400px;
  padding: 12px 20px;
  font-size: 1.2em;
  margin: 20px auto;
  display: block;
  border: 2px solid #ccc;
  border-radius: 5px;
  outline: none;
  box-sizing: border-box;
}
input#mealInput:focus {
  border-color: #007bff;
  box-shadow: 0 0 5px rgba(0, 123, 255, 0.5);
}
input#mealInput::placeholder {
  color: #aaa;
  font-style: italic;
}
#submitBtn {
  margin: 20px auto;
  font-size: 1.2em;
  width: 40%;
  touch-action: manipulation;
  -ms-touch-action: manipulation;
}
button#submitBtn:hover {
  background-color: #0056b3;
}

/* 菜单 */
.menu {
  margin-top: 30px;
  text-align: center;
  min-height: 40px;
}
.meal {
  font-size: 1.5em;
  color: #333;
  font-weight: bold;
  padding: 10px;
  background-color: #bababa;
  border-radius: 10px;
  border: 1px solid #ddd;
  display: inline-block;
  transform-origin: center;
}

/* 动画部分（核心） */
.fade-slide-move {
  transition: transform 0.4s ease;
}
.fade-slide-enter-active,
.fade-slide-leave-active {
  transition: all 0.4s ease;
}
.fade-slide-enter-from,
.fade-slide-leave-to {
  opacity: 0;
  transform: translateY(20px) scale(0.9);
}
.fade-slide-enter-to,
.fade-slide-leave-from {
  opacity: 1;
  transform: translateY(0) scale(1);
}

</style>
